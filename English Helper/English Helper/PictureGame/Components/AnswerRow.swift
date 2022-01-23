//
//  AnswerRow.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-20.
//

import SwiftUI

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
            HStack( spacing: 20){
                Image(systemName: "circle.fill")
                    .font(.caption)
                AsyncImage(url: answer.url){ phase in
                    switch phase{
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .scaledToFit()
                            .padding()
                    case .failure(_):
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                }
                Spacer()
                if isShowSelect{
                    Image(systemName: answer.isCorrect ? "checkmark.circle.fill" : "x.circle.fill")
                        .foregroundColor(answer.isCorrect ? .green : .red)
                }
            }
        }
        .frame(minWidth: 80, maxWidth: .infinity, minHeight: 80, maxHeight: 200)
//        .frame(maxWidth:.infinity,maxHeight: 200)
        .foregroundColor(Color("AccentColor"))
        .background()
        .cornerRadius(10)
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
        AnswerRow(answer: Answer(name: "period.png", isCorrect: false, chapter: "Computer", topic: "Program"))
            .environmentObject(PictureGameViewModel())
    }
}
