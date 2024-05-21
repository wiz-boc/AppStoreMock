//
//  SearchViewModel.swift
//  AppStoreMock
//
//  Created by wizz on 4/23/24.
//

import Foundation
import Combine

// ioS 17 has @Observable macro
@Observable
class SearchViewModel {
    
    var results: [Result] = [Result]()
    var query = "Pokemon" {
        didSet{
            if oldValue != query {
                queryPublisher.send(query)
            }
        }
    }
    var isSearching = false
    
    private var queryPublisher = PassthroughSubject<String,Never>()
    private var cancelable = Set<AnyCancellable>()
    
    init(){
        queryPublisher.debounce(for: 0.5, scheduler: DispatchQueue.main).sink { [weak self] newValue in
            guard let self else { return }
            self.fetchJSONData(searchValue: newValue)
        }.store(in: &cancelable)
        
    }
    
    private func fetchJSONData(searchValue: String){
        //contact sever for JSON data
        
        Task{
            do{
                isSearching = true
                self.results = try await APIService.fetchSearchResults(searchValue: searchValue)
                isSearching = false
            }catch{
                print("Failed due to error: ", error)
                isSearching = false
            }
        }
    }
}
