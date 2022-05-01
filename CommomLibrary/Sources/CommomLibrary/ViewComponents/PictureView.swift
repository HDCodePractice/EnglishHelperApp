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
    
    public init(url: URL?, errorMsg:String?=nil){
        self.url = url
        if let errorMsg = errorMsg {
            errorText = errorMsg
            isErrorText = true
        }
    }
    public var body: some View {
        ZStack{
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
                .scaledToFit()
            if isShowErrorMsg{
                Text(errorText)
            }
        }
    }
}

struct PictureView_Previews: PreviewProvider {
    static var previews: some View {
        PictureView(url: URL(string: "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/pictures/Clothing/Everyday%20Clothes/cap.jpg"))
    }
}
