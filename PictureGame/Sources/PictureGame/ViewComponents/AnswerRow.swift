//
//  AnswerRow.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-20.
//

import SwiftUI
import CommomLibrary

struct AnswerRow: View {
    let answer : Answer
    
    var body: some View {
        ZStack{
            PictureView(url: URL(string:answer.picUrl),errorMsg: answer.name)
            if answer.isSelected{
                Image(systemName: answer.isCorrect ? "checkmark.circle.fill" : "x.circle.fill")
                    .font(.largeTitle )
                    .foregroundColor(answer.isCorrect ? .green : .red)
                    .opacity(0.8)
            }
        }
        .frame(minWidth: 80, maxWidth: .infinity, minHeight: 80, maxHeight: .infinity)
        .foregroundColor(.accent)
        .background()
        .shadow(color: answer.isSelected ? (answer.isCorrect ? .green : .red) : .gray, radius: 5, x: 0.5, y: 0.5)
    }
}

struct AnswerRow_Previews: PreviewProvider {
    static var previews: some View {
        let vm = PictureGameViewModel()
        vm.generatePictureExam()
        return AnswerRow(answer: vm.answerChoices[0])
    }
}
