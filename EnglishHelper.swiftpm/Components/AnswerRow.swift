//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2021-12-31.
//

import SwiftUI

struct AnswerRow: View {
    @EnvironmentObject var imageExamManager : ImageExamManager
    
    let answer : Answer
    @State private var isSelected = false
    
    var body: some View {
        ZStack{
            Color("background")
            HStack( spacing: 20){
                Image(systemName: "circle.fill")
                    .font(.caption)
                Image(systemName: answer.name)
                    .resizable()
                    .scaledToFit()
                    .padding()
                Spacer()
                if isSelected{
                    Image(systemName: answer.isCorrect ? "checkmark.circle.fill" : "x.circle.fill")
                        .foregroundColor(answer.isCorrect ? .green : .red)
                }
            }
        }
        .frame(maxWidth:.infinity,maxHeight: 200)
        .foregroundColor(Color("AccentColor"))
        .background()
        .cornerRadius(10)
        .shadow(color: isSelected ? (answer.isCorrect ? .green : .red) : .gray, radius: 5, x: 0.5, y: 0.5)
        .onTapGesture {
            if !imageExamManager.answerSelected{
                isSelected = true
                imageExamManager.selectAnswer(answer: answer)
            }
        }
    }
}

struct AnswerRow_Previews: PreviewProvider {
    static var previews: some View {
        AnswerRow(answer: Answer(name: "sun.max",isCorrect: true))
            .environmentObject(ImageExamManager())
    }
}
