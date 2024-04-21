//
//  SearchView.swift
//  AppStoreMock
//
//  Created by wizz on 4/12/24.
//

import SwiftUI
import Combine

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
}

// ioS 17 has @Observable macro
@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var results: [Result] = [Result]()
    @Published var query = ""
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


struct SearchView: View {
    
    
    @StateObject var vm = SearchViewModel()
    var body: some View {
        NavigationStack{
            
            GeometryReader { proxy in
                ZStack{
                    if vm.isSearching {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .controlSize(.large)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    if vm.results.isEmpty && vm.query.isEmpty {
                        VStack(spacing: 16){
                            Image(systemName: "magnifyingglass.circle.fill")
                                .font(.system(size: 34) )
                            Text("Please enter your search terms above")
                                .font(.system(size: 24, weight: .semibold))
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }else{
                        ScrollView{
                            ForEach(vm.results) { result in
                                VStack(alignment: .leading, spacing: 16){
                                    AppIconTitleView(result: result)
                                    ScreenshotsRow(proxy: proxy, result: result)
                                }
                                .padding(16)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search")
            .searchable(text: $vm.query)
        }
    }
}

struct AppIconTitleView: View {
    
    let result: Result
    var body: some View {
        HStack(spacing: 16){
            AsyncImage(url: URL(string: result.artworkUrl512)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } placeholder: {
                RoundedRectangle(cornerRadius: 16)
                    .frame(width: 80, height: 80)
            }
            
            VStack(alignment: .leading){
                Text(result.trackName)
                    .lineLimit(1)
                    .font(.system(size: 20))
                Text("Photo & Video")
                    .foregroundStyle(.gray)
                Text("STARS 34.0M")
            }
            Spacer(minLength: 0)
            Image(systemName: "icloud.and.arrow.down")
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        
    }
}

struct ScreenshotsRow: View {
    
    let proxy: GeometryProxy
    let result: Result
    var body: some View {
        
        let width = (proxy.size.width - 4 * 16) / 3
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16){
                
                ForEach(result.screenshotUrls, id: \.self){ screenshot in
                    AsyncImage(url: URL(string: screenshot)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: width, height: 200)
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(width: width, height: 200)
                    }
                }
            }
        }
    }
}

#Preview {
    SearchView()
        .preferredColorScheme(.dark)
}
