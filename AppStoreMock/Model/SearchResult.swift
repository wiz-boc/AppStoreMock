//
//  SearchResult.swift
//  AppStoreMock
//
//  Created by wizz on 4/23/24.
//

import Foundation


struct SearchResult: Codable {
    let results: [Result]
}

struct Result: Codable, Identifiable {
    var id: Int { trackId }
    let trackId: Int
    let trackName: String
    let artworkUrl512: String
    let artistName: String
    let primaryGenreName: String
    let genres: [String]
    let screenshotUrls :[String]
    let userRatingCount: Int
    let averageUserRating: Double
}
