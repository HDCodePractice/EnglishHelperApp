//
//  ContentView.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-17.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView{
            VStack(spacing:50){
                NavigationLink{
                    PictureGame()
                } label: {
                    PrimaryButton(text: "Picture Game")
                }
                
                NavigationLink{
                    GrammarListView()
                } label: {
                    PrimaryButton(text: "Grammar Book")
                }
                
//                NavigationLink{
//                    SettingView()
//                } label: {
//                    PrimaryButton(text: "Dictionaries Setting")
//                }
            }
            .padding()
        }
        .navigationViewStyle(.stack)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
