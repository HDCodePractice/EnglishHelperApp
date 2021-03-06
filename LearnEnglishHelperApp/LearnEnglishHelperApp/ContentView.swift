//
//  ContentView.swift
//  LearnEnglishHelperApp
//
//  Created by 老房东 on 2022-02-22.
//

import SwiftUI
import CommomLibrary
import GrammarBook
import DictionaryLibrary
import PictureGame

struct ContentView: View {
    @EnvironmentObject var vm: LearnEnglishHelperViewModel
    
    var body: some View {
        NavigationView{
            VStack(spacing:50){
                NavigationLink{
                    PictureGameView()
                } label: {
                    PrimaryButton("Picture Game")
                }
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
                NavigationLink{
                    DictonarySearchMainView()
                } label: {
                    DictionaryPrimaryButton()
                }
                NavigationLink{
                    MainSettingView()
                } label: {
                    PrimaryButton("Setting")
                }
                if vm.isLoading{
                    HStack{
                        ProgressView()
                        Text("Syncing....")
                    }
                }
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
                .environmentObject(LearnEnglishHelperViewModel())
            ContentView()
                .environment(\.locale, .init(identifier: "zh"))
                .environmentObject(LearnEnglishHelperViewModel())
        }
    }
}
