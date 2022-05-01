//
//  AnswerGrid.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-23.
//

import SwiftUI

struct AnswerGrid: View {
    @EnvironmentObject var vm : PictureGameViewModel
    
    var body: some View {
        VStack(spacing:10){
            HStack(spacing:10){
                ForEach(vm.answerChoices.prefix(3)){ item in
                    AnswerRow(answer: item)
                        .environmentObject(vm)
                }
            }
            HStack{
                ForEach(vm.answerChoices.suffix(3)){ item in
                    AnswerRow(answer: item)
                        .environmentObject(vm)
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
