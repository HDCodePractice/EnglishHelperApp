//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-03-27.
//

import SwiftUI
import CommomLibrary
import RealmSwift
import TranslateView

struct WordDetailView: View {
    @ObservedRealmObject var item : Word
    @State var text : String?
    
    var body: some View {
        VStack{
            Text(item.name)
                .font(.largeTitle)
            HStack{
                PlayAudio(url: item.audioUrl,isAutoPlay: false)
                Button(){
                    text = "This is \(item.name)"
                }label: {
                    Image(systemName: "questionmark.circle")
                        .font(.title2)
                }.translateSheet($text)
                CopyToClipboard(putString: item.name)
            }
            Text(item.wordsTitle)
            PictureView(url: URL(string: item.pictureUrl))
                .shadow(radius: 10)
                .padding()
            Text(item.chapterName)
            Text(item.topicName)
        }
        .padding()
        .onDisappear {
            $item.isNew.wrappedValue = false
        }
    }
}



struct testWordDetailView: View {
    @ObservedResults(Word.self) var words
    
    var body: some View {
        WordDetailView(item: words.first!)
    }
}

struct testWordDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = RealmController.preview
        return testWordDetailView()
    }
}
