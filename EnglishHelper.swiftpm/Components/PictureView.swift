//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-01-04.
//

import SwiftUI
import ZoomableImageView

struct PictureView: View {
    var image : UIImage
    
    var body: some View {
        ZStack{
            ZoomableImageView(image: image)
        }
    }
}

struct PictureView_Previews: PreviewProvider {
    static var previews: some View {
        PictureView(image: UIImage(named: "punctuation1")!)
    }
}
