//
//  AppDetailResults.swift
//  AppStoreMock
//
//  Created by wizz on 5/19/24.
//

import SwiftUI

struct AppDetailResult: Codable {
    let resultCount: Int
    let results: [AppDetail]
    
}

struct AppDetail: Codable, Identifiable {
    var id: Int { trackId }
    let trackName: String
    let artistName: String
    let trackId: Int
    let artworkUrl512: String
    let releaseNotes: String
    let description: String
    let screenshotUrls: [String]
}
