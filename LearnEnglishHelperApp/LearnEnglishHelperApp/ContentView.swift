//
//  ContentView.swift
//  LearnEnglishHelperApp
//
//  Created by 老房东 on 2022-02-22.
//

import SwiftUI
import WordSearch
import CommomLibrary

struct ContentView: View {
    var body: some View {
        PrimaryButton(WordSearch().text)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
