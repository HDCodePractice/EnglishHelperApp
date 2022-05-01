//
//  File.swift
//  
//
//  Created by Lei Zhou on 3/6/22.
//

import Foundation
import SwiftUI
import CommomLibrary

struct QuestionItem: View {
    var answer: Answer
    var isShowSelected : Bool {
        return answer.isSeleted
    }
    var body: some View {
        ZStack {
            Color.clear
            PictureView(url: URL(string:answer.picUrl))
            if (isShowSelected) {
                Image(systemName: answer.isCorrect ? "checkmark.circle.fill" : "x.circle.fill")
                    .font(.largeTitle )
                    .foregroundColor(answer.isCorrect ? .green : .red)
                    .opacity(0.8)
                
            }
        }.shadow( color: isShowSelected ? (answer.isCorrect ? .green : .red) : .gray, radius: 5)
        
        
    }
}

struct QuestionItem_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            QuestionItem(answer: Answer(
                name: "blouse",
                isSeleted: true,
                isCorrect: true,
                picUrl: "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/pictures/Clothing/Everyday%20Clothes/blouse.jpg",
                filePath: "Clothing/Everyday%20Clothes/blouse"))
            QuestionItem(answer: Answer(
                name: "blouse",
                isSeleted: true,
                isCorrect: false,
                picUrl: "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/pictures/Clothing/Everyday%20Clothes/blouse.jpg",
                filePath: "Clothing/Everyday%20Clothes/blouse"))
            QuestionItem(answer: Answer(
                name: "blouse",
                isSeleted: false,
                isCorrect: false,
                picUrl: "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/pictures/Clothing/Everyday%20Clothes/blouse.jpg",
                filePath: "Clothing/Everyday%20Clothes/blouse"))
        }
        
    }
}
