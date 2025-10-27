//
//  jwpubAlgorithm.swift
//  html2jwpub
//
//  Created by Dario Ragusa on 10/05/25.
//

import Foundation
import CryptoKit
import Compression
import zlib

// 1. Determine the publication card hash
//    - Query the SQLite Publication table
//    - Create a list with the MepsLanguageIndex, Symbol, Year fields
//    - If the IssueTagNumber field is not zero, add it to the end of the list
//    - Join the list with underscores to one string, for example for w_S_202206.jwpub, this would be 1_w22_2022_20220600
//    - Calculate the SHA 256 hash of that string
//    - Calculate the bitwise XOR with 11cbb5587e32846d4c26790c633da289f66fe5842a3a585ce1bc3a294af5ada7
// 2. Decrypt the text
//    - Query a row from the Document, BibleChapter or BibleVerse table
//    - Read the encoded Content field
//    - Run AES-128-CBC, use the first 16 bytes of the hash as AES Key, and the last 16 bytes as Initialization Vector (IV)
//    - Run Zlib Inflate

class JwpubAlgorithm {
    let key: String = "11cbb5587e32846d4c26790c633da289f66fe5842a3a585ce1bc3a294af5ada7"
    var publicationCardHash: String = ""
    
    func xor(_ a: [UInt8], _ b: [UInt8]) -> [UInt8] {
        zip(a, b).map { $0 ^ $1 }
    }
    
    func hexStringToBytes(_ hex: String) -> [UInt8] {
        var bytes: [UInt8] = []
        var index = hex.startIndex
        while index < hex.endIndex {
            let nextIndex = hex.index(index, offsetBy: 2)
            if nextIndex <= hex.endIndex,
               let byte = UInt8(hex[index..<nextIndex], radix: 16) {
                bytes.append(byte)
            } else {
                return []
            }
            index = nextIndex
        }
        return bytes
    }
    
    init(MepsLanguageIndex: Int, Symbol: String, Year: Int, IssueTagNumber: Int = 0) {
        let pubString = "\(MepsLanguageIndex)_\(Symbol)_\(Year)" + (IssueTagNumber != 0 ? "_\(IssueTagNumber)" : "")
        let digest = SHA256.hash(data: pubString.data(using: .utf8)!)
        let cardHash = xor(Array(digest), Array(hexStringToBytes(key)))
        self.publicationCardHash = cardHash.map { String(format: "%02x", $0) }.joined()
        print("Publication card hash: \(publicationCardHash)")
    }
    
    private func decompress(_ data: Data) -> String {
        var buffer = [UInt8](repeating: 0, count: compression_encode_scratch_buffer_size(COMPRESSION_ZLIB))
        let result = data.subdata(in: 2 ..< data.count).withUnsafeBytes ({
            let read = compression_decode_buffer(&buffer, buffer.count, $0.baseAddress!.bindMemory(to: UInt8.self, capacity: 1),
                                                 data.count - 2, nil, COMPRESSION_ZLIB)
            return String(decoding: Data(bytes: buffer, count: read), as: UTF8.self)
        }) as String
        return result
    }
    
    func decrypt(content: Data) -> String {
        let fullHash = hexStringToBytes(publicationCardHash)
        guard fullHash.count == 32 else {
            fatalError("Invalid hash.")
        }
        let aes128 = AES(key: Data(fullHash[0..<16]), iv: Data(fullHash[16..<32]))
        let decryptedData = aes128?.decrypt(data: content)
        let data = decompress(decryptedData!)
        return data
    }
    
    func compressData(_ data: Data) -> Data? { // By ChatGPT
        var stream = z_stream()
        var status: Int32

        // https://refspecs.linuxbase.org/LSB_3.0.0/LSB-Core-generic/LSB-Core-generic/zlib-deflateinit2.html
        status = deflateInit2_(&stream,
                               Z_DEFAULT_COMPRESSION,
                               Z_DEFLATED,
                               MAX_WBITS,       // zlib header (automatic Huffman coding)
                               8,
                               Z_DEFAULT_STRATEGY, // Z_DEFAULT_STRATEGY Z_FILTERED Z_HUFFMAN_ONLY
                               ZLIB_VERSION,
                               Int32(MemoryLayout<z_stream>.size))

        guard status == Z_OK else { return nil }

        let bufferSize = 16384
        var compressedBuffer = Data(count: bufferSize)
        var compressedSize: Int = 0

        let result = data.withUnsafeBytes { inputPointer -> Data? in
            guard let inputBase = inputPointer.baseAddress else { return nil }

            return compressedBuffer.withUnsafeMutableBytes { outputPointer -> Data? in
                guard let outputBase = outputPointer.baseAddress else { return nil }

                stream.next_in = UnsafeMutablePointer<Bytef>(mutating: inputBase.assumingMemoryBound(to: Bytef.self))
                stream.avail_in = uint(data.count)

                stream.next_out = outputBase.assumingMemoryBound(to: Bytef.self)
                stream.avail_out = uint(bufferSize)

                status = deflate(&stream, Z_FINISH)
                guard status == Z_STREAM_END else {
                    deflateEnd(&stream)
                    return nil
                }

                compressedSize = Int(stream.total_out)
                deflateEnd(&stream)

                return nil
            }
        }

        if let _ = result {
            return nil
        }
        return compressedBuffer.prefix(compressedSize)
    }
    
    func encrypt(content: String) -> Data {
        let fullHash = hexStringToBytes(publicationCardHash)
        guard fullHash.count == 32 else {
            fatalError("Invalid hash.")
        }
        let compressedData = compressData(content.data(using: .utf8)!)!
        let aes128 = AES(key: Data(fullHash[0..<16]), iv: Data(fullHash[16..<32]))
        let data = aes128?.encrypt(data: compressedData)
        return data!
    }
}
