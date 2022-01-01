//
//  WordsGameProgressView.swift
//  EnglishHelper
//
//  Created by 老房东 on 2021-12-31.
//

import SwiftUI

struct WordsGameProgressView: View {
    @EnvironmentObject var imageExamManager : ImageExamManager
    
    var body: some View {
        if imageExamManager.reachedEnd{
            VStack(spacing:20){
                Text("Words Game")
                    .liacTitle()
                Text("Congratulations, you completed the game!")
                
                Text("You scored \(imageExamManager.score) out of \(imageExamManager.length)")
                
                Button{
                    imageExamManager.fetchImageExam()
                }label: {
                    PrimaryButton(text: "Play again")
                }
            }
            .foregroundColor(Color("AccentColor"))
            .padding()
            .frame(maxWidth:.infinity,maxHeight: .infinity)
            .background(Color("background"))
        }else{
            QuestionView()
                .environmentObject(imageExamManager)
        }
    }
}

struct WordsGameProgressView_Previews: PreviewProvider {
    static var previews: some View {
        WordsGameProgressView()
            .environmentObject(ImageExamManager())
    }
}
