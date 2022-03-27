//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-03-27.
//

import SwiftUI
import Kingfisher

public struct PictureView: View {
    var url : URL?
    
    public init(url: URL?){
        self.url = url
    }
    public var body: some View {
        KFImage(url)
            .diskCacheExpiration(.seconds(600))
            .resizable()
            .scaledToFit()
    }
}

struct PictureView_Previews: PreviewProvider {
    static var previews: some View {
        PictureView(url: URL(string: "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/pictures/Clothing/Everyday%20Clothes/cap.jpg"))
    }
}
