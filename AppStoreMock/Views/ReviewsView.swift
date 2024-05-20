//
//  ReviewsView.swift
//  AppStoreMock
//
//  Created by wizz on 5/16/24.
//

import SwiftUI


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
