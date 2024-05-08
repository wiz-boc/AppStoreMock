//
//  SearchView.swift
//  AppStoreMock
//
//  Created by wizz on 4/12/24.
//

import SwiftUI

extension Int {
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        }
        else {
            return "\(self)"
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
                                NavigationLink {
                                    AppDetailView(trackId: result.trackId)
                                } label: {
                                    VStack(alignment: .leading, spacing: 16){
                                        AppIconTitleView(result: result)
                                        ScreenshotsRow(proxy: proxy, result: result)
                                    }
                                    .foregroundStyle(Color(.label))
                                    .padding(16)
                                }
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
                HStack(spacing: 1){
                    ForEach(0..<Int(result.averageUserRating), id: \.self){ num in
                        Image(systemName: "star.fill")
                    }
                    ForEach(0..<5 - Int(result.averageUserRating), id: \.self){ num in
                        Image(systemName: "star")
                    }
                    Text("\(result.userRatingCount.roundedWithAbbreviations)")
                        .padding(.leading,4)
                }
                .padding(.top,0)
            }
            Spacer(minLength: 0)
            
            Button{} label: {
                Image(systemName: "icloud.and.arrow.down")
                    .font(.system(size: 24))
            }
            
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
