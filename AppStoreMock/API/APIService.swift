//
//  APIService.swift
//  AppStoreMock
//
//  Created by wizz on 5/19/24.
//

import Foundation

struct APIService {
    static func fetchAppDetail(trackId: Int) async throws -> AppDetail {
        let appDetailResults: AppDetailResult = try await decode(urlString: "https://itunes.apple.com/lookup?id=\(trackId)")
        if let appDetail = appDetailResults.results.first { return appDetail }
        
        throw APIError.appDetailNotFound
    }
    
    static func fetchSearchResults(searchValue: String) async throws -> [Result] {
        let searchResult:SearchResult = try await decode(urlString: "https://itunes.apple.com/search?term=\(searchValue)&entity=software")
        return searchResult.results
    }
    
    static func fetchReviews(trackId: Int) async throws -> [Review]{
        let reviewsResults: ReviewResults = try await decode(urlString: "https://itunes.apple.com/rss/customerreviews/page=1/id=\(trackId)/sortby=mostrecent/json?l=en&cc=us")
        return reviewsResults.feed.entry
    }
    
    //Use generics to clean up your code
    static private func decode<T: Codable>(urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else { throw APIError.invalidURL }
        let (data, response) = try await URLSession.shared.data(from: url)
        if let statusCode = (response as? HTTPURLResponse)?.statusCode,
           !(200..<299 ~= statusCode){
            throw APIError.badResponse(statusCode: statusCode)
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}

enum APIError: Error {
    case appDetailNotFound
    case invalidURL
    case badResponse(statusCode: Int)
}
