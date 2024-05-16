//
//  FullScreenScreenshotsView.swift
//  AppStoreMock
//
//  Created by wizz on 5/15/24.
//

import SwiftUI

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
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.viewAligned)
            }
        }
    }
}

#Preview {
    FullScreenScreenshotsView( screenshotUrls: [
        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/87/2f/5f/872f5f12-505c-12b1-9630-11818095eccf/71e55929-d183-4755-94df-2cfa4d2967ee_Dark_Mode_iOS_5.5_01.jpg/392x696bb.jpg",
        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/8c/ef/71/8cef714e-2478-9c3d-eef9-83f9b7f51edf/c19ffc34-067a-4f5d-8033-8de591e97f46_Dark_Mode_iOS_5.5_02.jpg/392x696bb.jpg",
        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/58/dd/72/58dd7243-9482-8526-f80e-51fac9bab4a2/f53b1922-3b20-4d7b-ade6-b7c6a86b3c61_Dark_Mode_iOS_5.5_03.jpg/392x696bb.jpg",
        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/2c/98/f5/2c98f561-4c8e-5fbd-38b6-489619f8e7d2/21f7a27f-815c-4bd7-abde-2db7d1601efb_Dark_Mode_iOS_5.5_04.jpg/392x696bb.jpg",
        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/e8/59/b5/e859b5ca-f212-76d5-e614-8f842c15dfed/a6d59920-fce3-4d16-a0fd-7ebcd8c1a252_Dark_Mode_iOS_5.5_05.jpg/392x696bb.jpg",
        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource126/v4/15/7e/aa/157eaa33-f754-e751-a6c4-cefb06c5b540/1a9a5bc6-1c1e-422e-967d-14fe7994129d_Dark_Mode_iOS_5.5_06.jpg/392x696bb.jpg",
        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/35/74/4e/35744e40-3db0-f98c-5f47-7d2aaf085fe6/8ad07a12-efa4-4b6f-8caa-9293db16c0ab_Dark_Mode_iOS_5.5_07.jpg/392x696bb.jpg",
        "https://is1-ssl.mzstatic.com/image/thumb/PurpleSource116/v4/8e/9e/06/8e9e064d-134f-42d7-08b2-a8e4304a7e79/8c878314-3df0-47ef-afb9-58a93dfb5f0b_Dark_Mode_iOS_5.5_08.jpg/392x696bb.jpg"
    ])
}
