//
//  jwpubCreator.swift
//  html2jwpub
//
//  Created by Dario Ragusa on 11/05/25.
//

import Foundation
import SQLite3
import ZIPFoundation
import CryptoKit

class JwpubCreator {
    
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    var folderPath: String = ""
    var dbName: String = ""
    var db: OpaquePointer?
    var pubTitle: String = ""
    var documentId = -1
    var multimediaId = -1
    var symbol: String = ""
    var year: Int = 0
    var mepsLanguageIndex: Int = 0
    var res: [String] = []
    
    init(folder: String, dbName: String) {
        let filePath = URL(fileURLWithPath: folder).appendingPathComponent("\(dbName).db")
        try? FileManager.default.removeItem(atPath: filePath.path)
        sqlite3_open(filePath.path, &db)
        self.folderPath = folder
        self.dbName = dbName
        //MARK: Init
        sqlite3_exec(db, dbQuery().InitStructure, nil, nil, nil)
        simpleInsert(query: dbQuery().AndroidMetadata)
    }
    
    private func simpleInsert(query: String) {
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &insertStatement, nil) == SQLITE_OK {
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func insertPublication(title: String, symbol: String, year: Int, mepsLanguageIndex: Int) {
        self.pubTitle = title
        self.symbol = symbol
        self.year = year
        self.mepsLanguageIndex = mepsLanguageIndex
        let titleString = (title as NSString).utf8String
        var insertStatement: OpaquePointer? = nil
        //MARK: Publication
        for query in [dbQuery().Publication, dbQuery().RefPublication] {
            insertStatement = nil
            if sqlite3_prepare_v2(db, query, -1, &insertStatement, nil) == SQLITE_OK {
                let symbolString = (symbol as NSString).utf8String
                sqlite3_bind_text(insertStatement, 1, titleString, -1, nil)
                sqlite3_bind_text(insertStatement, 2, symbolString, -1, nil)
                sqlite3_bind_int(insertStatement, 3, Int32(year))
                for i in 4...7 {
                    sqlite3_bind_text(insertStatement, Int32(i), titleString, -1, nil)
                }
                for i in 8...12 {
                    sqlite3_bind_text(insertStatement, Int32(i), symbolString, -1, nil)
                }
                sqlite3_bind_int(insertStatement, 13, Int32(year))
                sqlite3_bind_int(insertStatement, 14, Int32(mepsLanguageIndex))
                sqlite3_bind_int(insertStatement, 15, 12345)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted row.")
                } else {
                    print("Could not insert row.")
                }
            } else {
                print("INSERT statement could not be prepared.")
            }
            sqlite3_finalize(insertStatement)
        }
        //MARK: Publication*
        simpleInsert(query: dbQuery().PublicationAttribute)
        simpleInsert(query: dbQuery().PublicationCategory)
        simpleInsert(query: dbQuery().PublicationView)
        simpleInsert(query: dbQuery().PublicationViewSchema)
        simpleInsert(query: dbQuery().PublicationYear(year: year))
        insertStatement = nil
        //MARK: PublicationViewItem
        if sqlite3_prepare_v2(db, dbQuery().PublicationViewItem, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, 1)
            sqlite3_bind_int(insertStatement, 2, -1)
            sqlite3_bind_text(insertStatement, 3, titleString, -1, nil)
            sqlite3_bind_int(insertStatement, 4, 0)
            sqlite3_bind_int(insertStatement, 5, -1)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
        //MARK: PublicationViewItemField
        insertStatement = nil
        if sqlite3_prepare_v2(db, dbQuery().PublicationViewItemField, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, 1)
            sqlite3_bind_int(insertStatement, 2, 1)
            sqlite3_bind_text(insertStatement, 3, titleString, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func insertDocument(docTitle: String, content: String) {
        let jwpupAlgo = JwpubAlgorithm(MepsLanguageIndex: self.mepsLanguageIndex, Symbol: self.symbol, Year: self.year)
        let contentData = jwpupAlgo.encrypt(content: content)
        documentId += 1
        
        //MARK: Document
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, dbQuery().Document, -1, &insertStatement, nil) == SQLITE_OK {
            let titleString = (docTitle as NSString).utf8String
            sqlite3_bind_int(insertStatement, 1, Int32(documentId))
            sqlite3_bind_int(insertStatement, 2, Int32(12000000 + documentId + 1))
            sqlite3_bind_int(insertStatement, 3, Int32(self.mepsLanguageIndex))
            sqlite3_bind_text(insertStatement, 4, titleString, -1, nil)
            sqlite3_bind_text(insertStatement, 5, titleString, -1, nil)
            contentData.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
                if let baseAddress = bytes.baseAddress {
                    sqlite3_bind_blob(insertStatement, 6, baseAddress, Int32(contentData.count), SQLITE_TRANSIENT)
                }
            }
            sqlite3_bind_int(insertStatement, 7, Int32(content.count))
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
        
        //MARK: TextUnit
        insertStatement = nil
        if sqlite3_prepare_v2(db, dbQuery().TextUnit, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(documentId + 1))
            sqlite3_bind_int(insertStatement, 2, Int32(documentId))
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
        
        //MARK: PublicationViewItem
        insertStatement = nil
        if sqlite3_prepare_v2(db, dbQuery().PublicationViewItem, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(documentId + 2))
            sqlite3_bind_int(insertStatement, 2, 1)
            sqlite3_bind_text(insertStatement, 3, (title as NSString).utf8String, -1, nil)
            sqlite3_bind_null(insertStatement, 4)
            sqlite3_bind_int(insertStatement, 5, Int32(documentId))
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
        
        //MARK: PublicationViewItemDocument
        insertStatement = nil
        if sqlite3_prepare_v2(db, dbQuery().PublicationViewItemDocument, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(documentId + 1))
            sqlite3_bind_int(insertStatement, 2, Int32(documentId + 2))
            sqlite3_bind_int(insertStatement, 3, Int32(documentId))
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
        
        //MARK: PublicationViewItemField
        insertStatement = nil
        if sqlite3_prepare_v2(db, dbQuery().PublicationViewItemField, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(documentId + 2))
            sqlite3_bind_int(insertStatement, 2, Int32(documentId + 2))
            sqlite3_bind_text(insertStatement, 3, (title as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func insertMedia(mediaName: String, mimeType: String, resPath: String) {
        //MARK: Multimedia
        self.multimediaId += 1
        res.append(resPath)
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, dbQuery().Multimedia, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(self.multimediaId))
            sqlite3_bind_int(insertStatement, 2, 0)
            sqlite3_bind_int(insertStatement, 3, 1)
            sqlite3_bind_int(insertStatement, 4, 1)
            sqlite3_bind_text(insertStatement, 5, mimeType, -1, nil)
            sqlite3_bind_text(insertStatement, 6, mediaName, -1, nil)
            sqlite3_bind_text(insertStatement, 7, mediaName, -1, nil)
            sqlite3_bind_int(insertStatement, 8, -1)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
        
        //MARK: DocumentMultimedia
        insertStatement = nil
        if sqlite3_prepare_v2(db, dbQuery().DocumentMultimedia, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(self.documentId))
            sqlite3_bind_int(insertStatement, 2, Int32(self.multimediaId))
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func finalizeJwpub() {
        //MARK: Finalize
        sqlite3_close(db)
        let source = URL(fileURLWithPath: self.folderPath).appendingPathComponent("\(self.dbName).db")
        let destination = URL(fileURLWithPath: self.folderPath).appendingPathComponent("contents")
        let manifestPath = URL(fileURLWithPath: self.folderPath).appendingPathComponent("manifest.json")
        let jwpubFile = URL(fileURLWithPath: self.folderPath).appendingPathComponent("\(self.dbName).jwpub")
        try? FileManager.default.removeItem(atPath: destination.path)
        try? FileManager.default.removeItem(atPath: manifestPath.path)
        try? FileManager.default.removeItem(atPath: jwpubFile.path)
        do {
            try FileManager().zipItem(at: source, to: destination)
            print("Contents file created.")
            
            if res.count > 0 {
                let archive = try Archive(url: destination, accessMode: .update)
                try res.forEach { resource in
                    let resPath = URL(fileURLWithPath: resource)
                    try archive.addEntry(with: resPath.lastPathComponent, relativeTo: resPath.deletingLastPathComponent())
                }
            }
            
            let dbFile = try Data(contentsOf: source)
            let dbHash = Insecure.SHA1.hash(data: dbFile).makeIterator().map { String(format: "%02hhx", $0) }.joined()
            let contentsFile = try Data(contentsOf: destination)
            let contentsHash = SHA256.hash(data: contentsFile).makeIterator().map { String(format: "%02hhx", $0) }.joined()
            
            let formatter = ISO8601DateFormatter()
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            let timestamp = formatter.string(from: Date())
            
            var manifest = Manifest()
            manifest.name = "\(self.dbName).jwpub"
            manifest.hash = contentsHash
            manifest.timestamp = timestamp
            manifest.expandedSize = contentsFile.count
            manifest.publication.fileName = "\(self.dbName).db"
            manifest.publication.title = pubTitle
            manifest.publication.shortTitle = pubTitle
            manifest.publication.displayTitle = pubTitle
            manifest.publication.symbol = self.symbol
            manifest.publication.language = self.mepsLanguageIndex
            manifest.publication.hash = dbHash
            manifest.publication.timestamp = timestamp
            manifest.publication.year = self.year
            manifest.publication.rootSymbol = self.symbol
            manifest.publication.rootYear = self.year
            
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = [.prettyPrinted]
            let jsonData = try jsonEncoder.encode(manifest)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            try jsonString.write(to: manifestPath, atomically: true, encoding: .utf8)
            
            print("Manifest file created.")
            
            try FileManager().zipItem(at: destination, to: jwpubFile)
            let archive = try Archive(url: jwpubFile, accessMode: .update)
            try archive.addEntry(with: manifestPath.lastPathComponent, relativeTo: manifestPath.deletingLastPathComponent())
            
            print("Done.")
        } catch {
            print(error)
        }
    }
}
