//
//  AnswerRow.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-20.
//

import SwiftUI
import CommomLibrary

struct AnswerRow: View {
    @EnvironmentObject var vm : PictureGameViewModel
    let answer : Answer
    @State private var isSelected = false
    var isShowSelect : Bool{
        if isSelected { return true}
        if vm.answerSelected && answer.isCorrect { return true }
        return false
    }
    
    var body: some View {
        ZStack{
            PictureView(url: URL(string:answer.picUrl),errorMsg: answer.name,isFill: true)
            if isShowSelect{
                Image(systemName: answer.isCorrect ? "checkmark.circle.fill" : "x.circle.fill")
                    .font(.largeTitle )
                    .foregroundColor(answer.isCorrect ? .green : .red)
                    .opacity(0.8)
            }
        }
        .frame(minWidth: 80, maxWidth: .infinity, minHeight: 80, maxHeight: .infinity)
        .foregroundColor(.accent)
        .background()
        .shadow(color: isShowSelect ? (answer.isCorrect ? .green : .red) : .gray, radius: 5, x: 0.5, y: 0.5)
        .onTapGesture {
            if !vm.answerSelected{
                isSelected = true
                vm.selectAnswer(answer: answer)
            }
        }
    }
}

struct AnswerRow_Previews: PreviewProvider {
    static var previews: some View {
        let vm = PictureGameViewModel()
        vm.generatePictureExam()
        return AnswerRow(answer: vm.answerChoices[0])
            .environmentObject(vm)
    }
}
