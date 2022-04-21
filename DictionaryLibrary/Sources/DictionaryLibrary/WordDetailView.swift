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
            HStack{
                Text(item.name)
                    .font(.largeTitle)
                PlayAudio(url: item.audioUrl,isAutoPlay: false)
            }
            Text(item.wordsTitle)
            PictureView(url: URL(string: item.pictureUrl))
                .shadow(radius: 10)
                .padding()
            Text(item.chapterName)
            Text(item.topicName)
        }
    }
}
