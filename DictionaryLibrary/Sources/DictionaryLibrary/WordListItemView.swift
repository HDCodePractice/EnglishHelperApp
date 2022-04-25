//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-04-22.
//

import SwiftUI
import RealmSwift
import CommomLibrary

struct WordListItemView: View {
    @ObservedRealmObject var word : Word
    
    var body: some View {
        NavigationLink{
            WordDetailView(item: word)
        }label: {
            HStack{
                PictureView(url: URL(string: word.pictureUrl.urlEncoded()))
                    .frame(width: 60, height: 60)
                    .shadow(radius: 10)
                VStack(alignment:.leading){
                    HStack(spacing:1){
                        if word.isNew{
                            Image(systemName: "circle.fill")
                                .font(.caption2)
                                .foregroundColor(.cyan)
                                .shadow(radius: 5)
                        }
                        Text(word.name)
                            .font(.body)
                    }
                }
            }
        }
    }
}

struct testWordListItemView: View {
    @ObservedResults(Word.self) var words
    
    var body: some View {
        NavigationView{
            WordListItemView(word: words.first!)
        }
    }
}

struct testWordListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = RealmController.preview
        return testWordListItemView()
    }
}
