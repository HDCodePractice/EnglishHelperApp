//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-03-27.
//

import SwiftUI
import CommomLibrary

struct WordDetailView: View {
    var item : Word
    
    var body: some View {
        VStack{
            Text(item.viewModel.name)
                .font(.largeTitle)
            PlayAudio(url: item.viewModel.audioUrl,isAutoPlay: false)
            PictureView(url: URL(string: item.viewModel.pictureUrl))
                .shadow(radius: 10)
                .padding()
            Text((item.viewModel.picture?.viewModel.topic?.viewModel.chapter?.viewModel.name)!)
            Text((item.viewModel.picture?.viewModel.topic?.viewModel.name)!)
        }
    }
}
