//
//  manifest.swift
//  html2jwpub
//
//  Created by Dario Ragusa on 11/05/25.
//

struct Manifest: Codable {
    var name: String = ""
    var hash: String = ""
    var timestamp: String = ""
    var version: Int = 1
    var expandedSize: Int = 0
    var contentFormat: String = "z-a"
    var htmlValidated: Bool = false
    var mepsPlatformVersion : Double = 2.100000
    var mepsBuildNumber : Int = 12345
    var publication: ManifestPublication = ManifestPublication()
}

struct ManifestPublication: Codable {
    var fileName: String = ""
    var type: Int = 1
    var title: String = ""
    var shortTitle: String = ""
    var displayTitle: String = ""
    var referenceTitle: String = ""
    var undatedReferenceTitle: String = ""
    var titleRich: String = ""
    var displayTitleRich: String = ""
    var referenceTitleRich: String = ""
    var undatedReferenceTitleRich: String = ""
    var symbol: String = ""
    var uniqueEnglishSymbol: String = ""
    var uniqueSymbol: String = ""
    var englishSymbol: String = ""
    var language: Int = 1
    var hash: String = ""
    var timestamp: String = ""
    var minPlatformVersion: Int = 1
    var schemaVersion: Int = 8
    var year: Int = 0
    var issueId: Int = 0
    var issueNumber: Int = 0
    var publicationType: String = "Manual/Guidelines"
    var rootSymbol: String = ""
    var rootYear: Int = 0
    var rootLanguage: Int = 0
    var images: [String] = []
    var categories: [String] = ["manual"]
    var attributes: [String] = []
}
