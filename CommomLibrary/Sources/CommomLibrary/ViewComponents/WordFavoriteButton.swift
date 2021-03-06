//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-05-12.
//

import SwiftUI
import RealmSwift

public struct WordFavoriteButton: View {
    @ObservedRealmObject var word: Word
    @ObservedResults(WordSelect.self) var wordSelects
    var isButton: Bool
    
    public init(word: Word,isButton:Bool = false){
        self.word = word
        self.isButton = isButton
    }
    
    public var body: some View {
        let isFavorited = wordSelects.where({ $0.id==word.id && $0.isFavorited==true }).count > 0
        if isButton{
            if isFavorited{
                Button(){
                    word.toggleFavorite()
                }label: {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }else{
                Button(){
                    word.toggleFavorite()
                }label: {
                    Image(systemName: "star")
                }
            }
        }else{
            if isFavorited{
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        word.toggleFavorite()
                    }
            }else{
                Image(systemName: "star")
                    .foregroundColor(.accent)
                    .onTapGesture {
                        word.toggleFavorite()
                    }
            }
        }
    }
}

struct TestWordFavoriteButton: View {
    @ObservedResults(Word.self) var words
    
    var body: some View {
        NavigationView{
            WordFavoriteButton(word: words.first!)
            WordFavoriteButton(word: words.first!,isButton: true)
        }
    }
}


struct WordFavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        let _ = RealmController.preview
        return TestWordFavoriteButton()
    }
}
