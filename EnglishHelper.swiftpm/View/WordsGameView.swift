//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2021-12-31.
//

import SwiftUI

struct WordsGameView: View {
    @StateObject var imageExamManager = ImageExamManager()
    
    var body: some View {
        NavigationView{
            VStack(spacing:40){
                VStack(spacing:20){
                    Text("Words Game")
                        .liacTitle()
                    Text("Are you ready to test out English words?")
                        .foregroundColor(Color("AccentColor"))
                }
                NavigationLink{
                    WordsGameProgressView()
                        .environmentObject(imageExamManager)
                }label: {
                    PrimaryButton(text: "Let't go!")
                }
                
            }
            .padding()
            .frame(maxWidth:.infinity,maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
            .background(Color("background"))
        }.navigationViewStyle(.stack)
    }
}

struct WordsGameView_Previews: PreviewProvider {
    static var previews: some View {
        WordsGameView()
            .environmentObject(ImageExamManager())
.previewInterfaceOrientation(.landscapeRight)
    }
}
