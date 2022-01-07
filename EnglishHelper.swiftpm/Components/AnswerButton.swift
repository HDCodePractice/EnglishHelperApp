//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-01-04.
//

import SwiftUI

struct AnswerButton: View {
    @EnvironmentObject var pictureManager : PictureManager
    
    let answer : Answer
    @State private var isSelected = false
    var background: Color = Color("background")
    
    var body: some View {
        Text(answer.name)
            .foregroundColor(isSelected ? (answer.isCorrect ? .black : .red) : .white)
            .padding()
            .background(background)
            .cornerRadius(5)
            .shadow(
                color: isSelected ? (answer.isCorrect ? .green : .red) : .gray, radius: 5, x: 0.5, y: 0.5)
            .onTapGesture {
                if !pictureManager.answerSelected{
                    isSelected = true
                    pictureManager.selectAnswer(answer: answer)
                }
            }
    }
}

struct AnswerButton_Previews: PreviewProvider {
    static var previews: some View {
        AnswerButton(answer: Answer(name: "1", isCorrect: true))
            .environmentObject(PictureManager())
    }
}
