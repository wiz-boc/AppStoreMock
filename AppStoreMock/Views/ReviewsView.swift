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
    private let proxy: GeometryProxy
    
    init(trackId: Int, proxy: GeometryProxy){
        self._vm = .init(wrappedValue: .init(trackId: trackId))
        self.proxy = proxy
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
                HStack{
                    ForEach(vm.entries){ review in
                        VStack(alignment: .leading, spacing: 16){
                            HStack{
                                Text(review.title.label)
                                    .lineLimit(1)
                                    .font(.system(size: 20, weight: .semibold))
                                Spacer()
                                Text(review.author.name.label)
                                    .lineLimit(1)
                                    .foregroundStyle(Color(.lightGray))
                            }
                            HStack{
                                if let rating = Int(review.rating.label) {
                                    ForEach(0..<rating, id: \.self){ num in
                                        Image(systemName: "star.fill")
                                    }
                                    
                                    ForEach(0..<5 - rating, id: \.self){ num in
                                        Image(systemName: "star")
                                    }
                                }
                            }
                            Text(review.content.label)
                            Spacer()
                        }
                        .padding(20)
                        .frame(width: proxy.size.width - 64, height: 230)
                        .background(Color(.init(white: 1, alpha: 0.1)))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal, 16)
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
        }
}

#Preview {
    GeometryReader { proxy in
        ReviewsView(trackId: 547702041, proxy: proxy)
    }
    .preferredColorScheme(.dark)
}
