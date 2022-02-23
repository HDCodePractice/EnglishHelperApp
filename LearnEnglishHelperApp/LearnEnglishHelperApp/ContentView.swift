//
//  ContentView.swift
//  LearnEnglishHelperApp
//
//  Created by 老房东 on 2022-02-22.
//

import SwiftUI
import CommomLibrary
import GrammarBook

struct ContentView: View {
    var body: some View {
        NavigationView{
            VStack(spacing:50){
//                NavigationLink{
//                    PictureGame()
//                } label: {
//                    PrimaryButton(text: "Picture Game")
//                }
//                NavigationLink{
//                    WordSearch()
//                } label: {
//                    PrimaryButton(text: "Word Search")
//                }
                NavigationLink{
                    GrammarListView()
                } label: {
                    PrimaryButton("Grammar Book")
                }
//                NavigationLink{
//                    ListTopicView()
//                } label: {
//                    PrimaryButton(text: "Browse Dictionary")
//                }
                Spacer()
                NavigationLink{
                    AboutView()
                }label: {
                    Text("About")
                }
            }
            .padding()
        }
        .navigationViewStyle(.stack)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            ContentView()
                .environment(\.locale, .init(identifier: "en"))
            ContentView()
                .environment(\.locale, .init(identifier: "zh"))
        }
    }
}
