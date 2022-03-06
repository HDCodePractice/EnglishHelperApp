//
//  File.swift
//  
//
//  Created by Lei Zhou on 3/6/22.
//

import Foundation
import SwiftUI

struct QuestionItem: View {
    var answer: Answer
    var isShowSelected : Bool {
        return answer.isSeleted
    }
    var body: some View {
        ZStack {
            Color.clear
            AsyncImage(url: answer.picUrl)
            {
                image in
                
                image.resizable()
                    .scaledToFit()
                    .padding()
            } placeholder: {
                ProgressView()
            }
            if (isShowSelected) {
                Image(systemName: answer.isCorrect ? "checkmark.circle.fill" : "x.circle.fill")
                    .font(.largeTitle )
                    .foregroundColor(answer.isCorrect ? .green : .red)
                    .opacity(0.8)

            }
        }.shadow( color: isShowSelected ? (answer.isCorrect ? .green : .red) : .gray, radius: 5)
        
        
    }
    
    struct QuestionItem_Previews: PreviewProvider {
        static var previews: some View {
            Group{
                QuestionItem(answer: Answer(picUrl: URL(string: "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/pictures/Clothing/Everyday%20Clothes/blouse.jpg")!,isSeleted: true, isCorrect: true))
                QuestionItem(answer: Answer(picUrl: URL(string: "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/pictures/Clothing/Everyday%20Clothes/blouse.jpg")!,isSeleted: true, isCorrect: false))
                QuestionItem(answer: Answer(picUrl: URL(string: "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/pictures/Clothing/Everyday%20Clothes/blouse.jpg")!,isSeleted: false, isCorrect: false))
            }
            
        }
    }
}
