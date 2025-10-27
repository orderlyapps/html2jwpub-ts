//
//  main.swift
//  html2jwpub
//
//  Created by Dario Ragusa on 10/05/25.
//

import Foundation

print("Hello, World!")

// Test.run()

print("HTML folder:")
let folder = readLine(strippingNewline: true)!
print("MepsLanguageIndex:")
let mepsLanguageIndex: Int = Int(readLine(strippingNewline: true)!)!
print("Symbol:")
let symbol: String = readLine(strippingNewline: true)!
print("Year:")
let year: Int = Int(readLine(strippingNewline: true)!)!
print("Title:")
let title: String = readLine(strippingNewline: true)!

let jwpubCreator = JwpubCreator(folder: folder, dbName: symbol)
jwpubCreator.insertPublication(title: title, symbol: symbol, year: year, mepsLanguageIndex: mepsLanguageIndex)

try FileManager().contentsOfDirectory(atPath: folder).forEach { fileName in
    if fileName.hasSuffix(".html") {
        print("Processing \(fileName)")
        let filePath = folder + "/" + fileName
        let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
        let resFolder = filePath.replacingOccurrences(of: ".html", with: "")
        if FileManager().fileExists(atPath: resFolder) {
            try FileManager().contentsOfDirectory(atPath: resFolder).forEach { resName in
                let resPath = resFolder + "/" + resName
                let mediaData = try? Data(contentsOf: URL(fileURLWithPath: resPath))
                print("Processing \(resName)")
                jwpubCreator.insertMedia(mediaName: resName, mimeType: mediaData!.mimeType, resPath: resPath)
            }
        }
        jwpubCreator.insertDocument(docTitle: fileName.replacingOccurrences(of: ".html", with: ""), content: fileContent)
    }
}

jwpubCreator.finalizeJwpub()
