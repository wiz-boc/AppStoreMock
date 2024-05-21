//
//  AppDetailViewModel.swift
//  AppStoreMock
//
//  Created by wizz on 5/20/24.
//

import Foundation

@MainActor
class AppDetailViewModel: ObservableObject {
    
    @Published var appDetail: AppDetail?
    @Published var error: Error?
    private let trackId: Int
    
    init(trackId: Int){
        //fetch JSON Data
        self.trackId = trackId
        fetchJSONData()
    }
    
    private func fetchJSONData(){
        Task{
            do{
                self.appDetail = try await APIService.fetchAppDetail(trackId: trackId)
            }catch{
                self.error = error
            }
        }
        
    }
}
