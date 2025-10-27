import CryptoJS from 'crypto-js';
import pako from 'pako';

/**
 * JwpubAlgorithm handles encryption and decryption of JWPUB content
 * 
 * Algorithm:
 * 1. Determine the publication card hash
 *    - Create string from MepsLanguageIndex_Symbol_Year (and IssueTagNumber if not zero)
 *    - Calculate SHA-256 hash of that string
 *    - XOR with the constant key
 * 2. Encrypt/Decrypt content
 *    - Use AES-128-CBC with first 16 bytes as key and last 16 bytes as IV
 *    - Apply/remove zlib compression
 */
export class JwpubAlgorithm {
  private readonly KEY = '11cbb5587e32846d4c26790c633da289f66fe5842a3a585ce1bc3a294af5ada7';
  private publicationCardHash: string;

  constructor(
    mepsLanguageIndex: number,
    symbol: string,
    year: number,
    issueTagNumber: number = 0
  ) {
    const pubString = `${mepsLanguageIndex}_${symbol}_${year}${issueTagNumber !== 0 ? `_${issueTagNumber}` : ''}`;
    const hash = CryptoJS.SHA256(pubString);
    const cardHash = this.xor(this.hexToBytes(hash.toString()), this.hexToBytes(this.KEY));
    this.publicationCardHash = this.bytesToHex(cardHash);
    console.log('Publication card hash:', this.publicationCardHash);
  }

  private xor(a: Uint8Array, b: Uint8Array): Uint8Array {
    const result = new Uint8Array(a.length);
    for (let i = 0; i < a.length; i++) {
      result[i] = a[i] ^ b[i];
    }
    return result;
  }

  private hexToBytes(hex: string): Uint8Array {
    const bytes = new Uint8Array(hex.length / 2);
    for (let i = 0; i < hex.length; i += 2) {
      bytes[i / 2] = parseInt(hex.substr(i, 2), 16);
    }
    return bytes;
  }

  private bytesToHex(bytes: Uint8Array): string {
    return Array.from(bytes)
      .map(b => b.toString(16).padStart(2, '0'))
      .join('');
  }

  /**
   * Decrypt JWPUB content
   * @param content Encrypted content as Uint8Array
   * @returns Decrypted string
   */
  decrypt(content: Uint8Array): string {
    const fullHash = this.hexToBytes(this.publicationCardHash);
    if (fullHash.length !== 32) {
      throw new Error('Invalid hash length');
    }

    const key = this.uint8ArrayToWordArray(fullHash.slice(0, 16));
    const iv = this.uint8ArrayToWordArray(fullHash.slice(16, 32));
    
    const encryptedData = this.uint8ArrayToWordArray(content);
    const decrypted = CryptoJS.AES.decrypt(
      { ciphertext: encryptedData } as any,
      key,
      {
        iv: iv,
        mode: CryptoJS.mode.CBC,
        padding: CryptoJS.pad.Pkcs7
      }
    );

    const decryptedBytes = this.wordArrayToUint8Array(decrypted);
    const decompressed = pako.inflate(decryptedBytes);
    return new TextDecoder().decode(decompressed);
  }

  /**
   * Encrypt and compress content for JWPUB
   * @param content String content to encrypt
   * @returns Encrypted data as Uint8Array
   */
  encrypt(content: string): Uint8Array {
    const fullHash = this.hexToBytes(this.publicationCardHash);
    if (fullHash.length !== 32) {
      throw new Error('Invalid hash length');
    }

    // Compress using zlib
    const contentBytes = new TextEncoder().encode(content);
    const compressed = pako.deflate(contentBytes);

    // Convert Uint8Array to WordArray properly
    const compressedWords: number[] = [];
    for (let i = 0; i < compressed.length; i += 4) {
      const word = (compressed[i] << 24) | 
                   ((compressed[i + 1] || 0) << 16) | 
                   ((compressed[i + 2] || 0) << 8) | 
                   (compressed[i + 3] || 0);
      compressedWords.push(word);
    }

    // Encrypt using AES-128-CBC
    const key = this.uint8ArrayToWordArray(fullHash.slice(0, 16));
    const iv = this.uint8ArrayToWordArray(fullHash.slice(16, 32));
    const dataToEncrypt = CryptoJS.lib.WordArray.create(compressedWords, compressed.length);

    const encrypted = CryptoJS.AES.encrypt(dataToEncrypt, key, {
      iv: iv,
      mode: CryptoJS.mode.CBC,
      padding: CryptoJS.pad.Pkcs7
    });

    return this.wordArrayToUint8Array(encrypted.ciphertext);
  }

  private uint8ArrayToWordArray(bytes: Uint8Array): CryptoJS.lib.WordArray {
    const words: number[] = [];
    for (let i = 0; i < bytes.length; i += 4) {
      const word = (bytes[i] << 24) | 
                   ((bytes[i + 1] || 0) << 16) | 
                   ((bytes[i + 2] || 0) << 8) | 
                   (bytes[i + 3] || 0);
      words.push(word);
    }
    return CryptoJS.lib.WordArray.create(words, bytes.length);
  }

  private wordArrayToUint8Array(wordArray: CryptoJS.lib.WordArray): Uint8Array {
    const words = wordArray.words;
    const sigBytes = wordArray.sigBytes;
    const bytes = new Uint8Array(sigBytes);
    
    for (let i = 0; i < sigBytes; i++) {
      bytes[i] = (words[i >>> 2] >>> (24 - (i % 4) * 8)) & 0xff;
    }
    
    return bytes;
  }
}
