//
//  ReviewsViewModel.swift
//  AppStoreMock
//
//  Created by wizz on 5/19/24.
//

import Foundation

@Observable
class ReviewsViewModel {
    
    var entries: [Review] = [Review]()
    init(trackId: Int){
        fetchReviews(trackId: trackId)
    }
    
    private func fetchReviews(trackId: Int){
        Task{
            do{
               self.entries = try await APIService.fetchReviews(trackId: trackId)
               // self.entries = try await APIService.asyncLegacyFetchReviews(trackId: trackId)
            }catch{
                print("Some thing went wrong :",error)
            }
        }
    }
}
