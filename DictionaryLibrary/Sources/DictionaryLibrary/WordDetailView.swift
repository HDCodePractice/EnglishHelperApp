//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-03-27.
//

import SwiftUI
import CommomLibrary
import RealmSwift

struct WordDetailView: View {
    @ObservedRealmObject var item : Word
    
    var body: some View {
        VStack{
            HStack{
                Text(item.name)
                    .font(.largeTitle)
                PlayAudio(url: item.audioUrl,isAutoPlay: false)
            }
            Text(item.wordsTitle)
            PictureView(url: URL(string: item.pictureUrl.urlEncoded()))
                .shadow(radius: 10)
                .padding()
            Text(item.chapterName)
            Text(item.topicName)
        }
    }
}



private struct testView: View {
    @ObservedResults(Word.self) var words
    
    var body: some View {
        WordDetailView(item: words.first!)
    }
}

struct testView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = RealmController.preview
        return testView()
    }
}
