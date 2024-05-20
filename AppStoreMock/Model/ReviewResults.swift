//
//  ReviewResults.swift
//  AppStoreMock
//
//  Created by wizz on 5/16/24.
//

import Foundation
struct ReviewResults: Codable {
    let feed: ReviewFeed
}

struct ReviewFeed: Codable {
    let entry: [Review]
}

struct Review: Codable, Identifiable {
    var id: String { content.label }
    let content: JSONLabel
    let title: JSONLabel
    let author: Author
    let rating: JSONLabel
    
    private enum CodingKeys: String, CodingKey {
        case author
        case title
        case content
        case rating = "im:rating"
    }
    
}

struct JSONLabel: Codable {
    let label: String
}

struct Author: Codable {
    let name: JSONLabel
}
