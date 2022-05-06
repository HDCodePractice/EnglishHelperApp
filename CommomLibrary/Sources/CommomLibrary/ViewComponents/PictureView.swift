//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-03-27.
//

import SwiftUI
import Kingfisher

public struct PictureView: View {
    @State private var isShowErrorMsg = false
    
    var url : URL?
    var errorText = ""
    var isErrorText = false
    var isFill = false
    
    public init(url: URL?, errorMsg:String?=nil, isFill:Bool=false){
        self.url = url
        if let errorMsg = errorMsg {
            errorText = errorMsg
            isErrorText = true
        }
        self.isFill = isFill
    }
    public var body: some View {
        ZStack{
            if isFill{
                Color.clear.overlay{
                    image
                        .scaledToFill()
                }
                .clipped()
            }else{
                image
                    .scaledToFit()
            }
            if isShowErrorMsg{
                Text(errorText)
            }
        }
    }
    
    var image: some View{
        KFImage(url)
            .placeholder({
                ProgressView()
            })
            .diskCacheExpiration(.seconds(600))
            .onFailure({ _ in
                if isErrorText{
                    isShowErrorMsg = true
                }
            })
            .resizable()
    }
}

struct PictureView_Previews: PreviewProvider {
    static var previews: some View {
        PictureView(url: URL(string: "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/pictures/Clothing/Everyday%20Clothes/cap.jpg"))
    }
}
