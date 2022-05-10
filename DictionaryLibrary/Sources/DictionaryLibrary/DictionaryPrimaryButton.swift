//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-05-10.
//

import SwiftUI
import RealmSwift
import CommomLibrary

public struct DictionaryPrimaryButton: View {
    @ObservedResults(Word.self) var words
    
    public init(){}
    
    public var body: some View {
        let wordCount = words.where{
            $0.isNew == true
        }.count
        let showNew = wordCount < 1 ? "" : wordCount>99 ? "99+" : "\(wordCount)"
        PrimaryButton("Dictionary",newNumber: showNew)
    }
}

struct DictionaryPrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryPrimaryButton()
    }
}
