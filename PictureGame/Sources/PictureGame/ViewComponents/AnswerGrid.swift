//
//  AnswerGrid.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-23.
//

import SwiftUI
import CommomLibrary

struct AnswerGrid: View {
    @EnvironmentObject var vm : PictureGameViewModel
    @State var showOneAnswer: Answer?
    var columns:Int = 3
    var rows:Int = 2
    
    var body: some View {
        if let showOneAnswer=showOneAnswer,vm.isShowOne{
            ZStack{
                // 显示单一放大图片
                Color.clear
                PictureView(
                    url: URL(string:showOneAnswer.picUrl),
                    errorMsg: showOneAnswer.name
                )
                .shadow(color: showOneAnswer.isSelected ? (showOneAnswer.isCorrect ? .green : .red) : .gray, radius: 5, x: 0.5, y: 0.5)
                .onTapGesture{
                    withAnimation {
                        vm.isShowOne = false
                    }
                }
            }
        }else{
            VStack(spacing:10){
                ForEach(1...rows,id:\.self){row in
                    HStack(spacing:10){
                        ForEach(1...columns,id:\.self){ column in
                            let item = vm.answerChoices[row*columns+column-columns-1]
                            AnswerRow(answer: item)
                                .onTapGesture(count: 2) {
                                    withAnimation {
                                        vm.isShowOne = true
                                        showOneAnswer = item
                                        
                                    }
                                }
                                .onTapGesture(count: 1) {
                                    if !vm.answerSelected{
                                        vm.selectAnswer(answer: item)
                                    }
                                }
                        }
                    }
                }
            }
        }
    }
}

struct AnswerGrid_Previews: PreviewProvider {
    static var previews: some View {
        let vm = PictureGameViewModel(isPreview: true)
        vm.generatePictureExam()
        return AnswerGrid()
            .environmentObject(vm)
    }
}
