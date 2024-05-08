//
//  SearchViewModel.swift
//  AppStoreMock
//
//  Created by wizz on 4/23/24.
//

import Foundation
import Combine

// ioS 17 has @Observable macro
@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var results: [Result] = [Result]()
    @Published var query = "Pokemon"
    @Published var isSearching = false
    
    private var cancelable = Set<AnyCancellable>()
    
    init(){
        $query.debounce(for: 0.5, scheduler: DispatchQueue.main).sink { [weak self] newValue in
            guard let self else { return }
            self.fetchJSONData(searchValue: newValue)
        }.store(in: &cancelable)
        
    }
    
    private func fetchJSONData(searchValue: String){
        //contact sever for JSON data
        Task{
            do{
                guard let url = URL(string: "https://itunes.apple.com/search?term=\(searchValue)&entity=software") else { return }
                isSearching = true
                let (data, _) = try await URLSession.shared.data(from: url)
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                
                //DispatchQueue.main.async {
                //    self.results = searchResult.results
                //}
                //Task { @MainActor in
                //    self.results = searchResult.results
                //}
                self.results = searchResult.results
                isSearching = false
            }catch{
                print("Failed due to error: ", error)
                isSearching = false
            }
        }
    }
}
