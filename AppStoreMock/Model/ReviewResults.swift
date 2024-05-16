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
}

struct JSONLabel: Codable {
    let label: String
}

//{
//    "feed": {
//        "author": {
//            "name": { "label": "iTunes Store" },
//            "uri": { "label": "http://www.apple.com/itunes/" }
//        },
//        "entry": [
//            {
//                "author": {
//                    "uri": { "label": "https://itunes.apple.com/us/reviews/id147685188" },
//                    "name": { "label": "FlipsideRide111111" },
//                    "label": ""
//                },
//                "updated": { "label": "2024-05-15T00:32:45-07:00" },
//                "im:rating": { "label": "1" },
//                "im:version": { "label": "15.7.0" },
//                "id": { "label": "11269058980" },
//                "title": { "label": "Perfect" },
//                "content": {
//                    "label": "The perfect app to exclusively meet women 3000 miles away",
//                    "attributes": { "type": "text" }
//                },
//                "link": {
//                    "attributes": {
//                        "rel": "related",
//                        "href": "https://itunes.apple.com/us/review?id=547702041&type=Purple%20Software"
//                    }
//                },
//                "im:voteSum": { "label": "0" },
//                "im:contentType": {
//                    "attributes": { "term": "Application", "label": "Application" }
//                },
//                "im:voteCount": { "label": "0" }
//            },
