//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-01-04.
//

import SwiftUI
import ZoomableImageView

struct PictureView: View {
    var imageName : String
    
    var body: some View {
        ZStack{
            ZoomableImageView(image: UIImage(named: imageName)!)
        }
    }
}

struct PictureView_Previews: PreviewProvider {
    static var previews: some View {
        PictureView(imageName: "punctuation1")
    }
}
