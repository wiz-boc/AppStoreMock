//
//  AppDetailView.swift
//  AppStoreMock
//
//  Created by wizz on 5/6/24.
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

@MainActor
class AppDetailViewModel: ObservableObject {
    
    
    @Published var appDetail: AppDetail?
    private let trackId: Int
    
    init(trackId: Int){
        //fetch JSON Data
        self.trackId = trackId
        fetchJSONData()
    }
    
    private func fetchJSONData(){
        
        Task{
            do{
                guard let url = URL(string: "https://itunes.apple.com/lookup?id=\(trackId)") else { return }
                let (data, _) = try await URLSession.shared.data(from: url)
                //print(String(data:data, encoding: .utf8))
                let appDetailResults = try JSONDecoder().decode(AppDetailResult.self, from: data)
                self.appDetail = appDetailResults.results.first
            }catch{
                print("Failed to fetch app detail:", error)
            }
        }
    }
}

struct AppDetailView: View {
    
    @StateObject var vm: AppDetailViewModel
    
    init(trackId: Int) {
        self.trackId = trackId
        self._vm = .init(wrappedValue: AppDetailViewModel(trackId: trackId))
    }
    
    let trackId: Int
    var body: some View {
        ScrollView{
            if let appDetail = vm.appDetail {
                HStack(spacing: 16){
                    AsyncImage(url: URL(string: appDetail.artworkUrl512)) { image in
                        image
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .scaledToFill()
                    } placeholder: {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 100, height: 100)
                    }
                    VStack(alignment: .leading){
                        Text(appDetail.trackName)
                            .font(.system(size: 24, weight: .semibold))
                        Text(appDetail.artistName)
                        Image(systemName: "icloud.and.arrow.down")
                            .font(.system(size: 24))
                            .padding(.vertical,4)
                    }
                    Spacer()
                }
                .padding()
                
                VStack(alignment: .leading){
                    HStack{
                        Text("What's New")
                            .font(.system(size: 24, weight: .semibold))
                            .padding(.vertical)
                        Spacer()
                        Button{} label: {
                            Text("Version History")
                        }
                    }
                    Text(appDetail.releaseNotes)
                }
                .padding(.horizontal)
                
                previewScreenshots
                
                VStack(alignment: .leading){
                    Text("Description")
                        .font(.system(size: 24, weight: .semibold))
                        .padding(.vertical)
                    Text(appDetail.description)
                }
                .padding(.horizontal)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
       // .navigationTitle("Search")
    }
    @State var isPresentingFullScreenScreenshots = false
    
    private var previewScreenshots: some View {
        VStack{
            Text("Preview")
                .font(.system(size: 24, weight: .semibold))
                .padding(.vertical)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            ScrollView(.horizontal) {
                HStack(spacing: 16){
                    ForEach(vm.appDetail?.screenshotUrls ?? [], id: \.self){ screenshotUrl in
                        Button {
                            isPresentingFullScreenScreenshots.toggle()
                        } label: {
                            AsyncImage(url: URL(string: screenshotUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 350)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: 200, height: 350)
                                    .foregroundStyle(Color(.label))
                            }
                        }

                        
                    }
                }
                .padding(.horizontal)
            }
        }
        .fullScreenCover(isPresented: $isPresentingFullScreenScreenshots, content: {
            FullScreenScreenshotsView(screenshotUrls: vm.appDetail?.screenshotUrls ?? [])
        })
    }
}

struct FullScreenScreenshotsView: View {
    @Environment(\.dismiss) var dismiss
    let screenshotUrls: [String]
    var body: some View {
        GeometryReader { proxy in
            ZStack{
                VStack{
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color(.label))
                            .font(.system(size: 24, weight: .semibold))
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                
                ScrollView(.horizontal){
                    HStack{
                        ForEach(screenshotUrls, id: \.self){ screenshotUrl in
                            let width = proxy.size.width - 64
                            AsyncImage(url: URL(string: screenshotUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: width, height: 550)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 12)
                                    .frame(width: width, height: 550)
                                    .foregroundStyle(Color(.label))
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                }
            }
        }
    }
}
 
#Preview {
    NavigationStack{
        AppDetailView(trackId: 547702041)
            .preferredColorScheme(.dark )
    }
}
