//
//  ReviewsView.swift
//  AppStoreMock
//
//  Created by wizz on 5/16/24.
//

import SwiftUI


class ReviewsViewModel: ObservableObject {
    
    @Published var entries: [Review] = [Review]()
    init(trackId: Int){
        fetchReviews(trackId: trackId)
    }
    
    private func fetchReviews(trackId: Int){
        //https://itunes.apple.com/rss/customerreviews/page=1/id=547702041/sortby=mostrecent/json?l=en&cc=us
        
        Task{
            do{
                guard let url = URL(string: "https://itunes.apple.com/rss/customerreviews/page=1/id=\(trackId)/sortby=mostrecent/json?l=en&cc=us") else { return }
                let (data, _) = try await URLSession.shared.data(from: url)
                let reviewsResults = try JSONDecoder().decode(ReviewResults.self, from: data)
                self.entries = reviewsResults.feed.entry

            }catch{
                print("Some thing went wrong :",error)
            }
        }
    }
}

struct ReviewsView: View {
    
    @StateObject var vm: ReviewsViewModel
    
    init(trackId: Int){
        self._vm = .init(wrappedValue: .init(trackId: trackId))
    }
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(.horizontal) {
                HStack{
                    ForEach(vm.entries){ review in
                        VStack{
                            Text(review.content.label)
                                .padding()
                        }
                        .padding()
                        .frame(width: proxy.size.width - 64, height: 230)
                        .background(Color(.init(white: 1, alpha: 0.1)))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(16)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

#Preview {
    ReviewsView(trackId: 547702041)
        .preferredColorScheme(.dark)
}
