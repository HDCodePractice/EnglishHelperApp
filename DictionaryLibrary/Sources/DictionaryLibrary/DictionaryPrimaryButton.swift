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
    @ObservedResults(WordSelect.self) var wordSelects
    
    public init(){}
    
    public var body: some View {
        let wordCount = words.count
        let isNotNewCount = wordSelects.where {
            $0.isNew==false && $0.isDeleted==false
        }.count
        let newCount = wordCount - isNotNewCount
        let showNew = newCount < 1 ? "" : newCount>99 ? "99+" : "\(newCount)"
        PrimaryButton("Dictionary",newNumber: showNew)
    }
}

struct DictionaryPrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        DictionaryPrimaryButton()
    }
}
