//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2021-12-31.
//

import SwiftUI
import TranslateController

struct QuestionView: View {
    @EnvironmentObject var imageExamManager : ImageExamManager
    @State var text = ""
    @State var show_translate = false
    
    var body: some View {
        VStack(spacing: 40){
            HStack{
                Text("Words Game")
                    .liacTitle()
                Spacer()
                Text("\(imageExamManager.index+1) out of \(imageExamManager.length)")
                    .foregroundColor(Color("AccentColor"))
                    .fontWeight(.heavy)
            }
            ProgressBar(progress: imageExamManager.progress)
            VStack(){
                Text("Tap the answer of")
                    .font(.subheadline.weight(.heavy))
                    .foregroundColor(.gray)
                HStack{
                    Spacer()
                    Text(imageExamManager.question)
                        .font(.largeTitle.weight(.heavy))
                        .foregroundColor(Color("primary"))
                        .multilineTextAlignment(.center)
                    Spacer()
                    TranslateController(text: $text, showing: $show_translate)
                        .frame(width: 0, height: 0)
                    Button(){
                        text = imageExamManager.question
                        show_translate = true
                    }label: {
                        Image(systemName: "figure.wave.circle")
                    }
                }
                VStack(spacing: 20){
                    ForEach(imageExamManager.answerChoices){ answer in
                        AnswerRow(answer: answer)
                            .environmentObject(imageExamManager)
                    }
                }
            }
            Button{
                imageExamManager.goToNextQuestion()
            }label: {
                PrimaryButton(
                    text: "Next",
                    background: imageExamManager.answerSelected ? Color("AccentColor") : Color(.gray)
                )
            }
            .disabled(!imageExamManager.answerSelected)
            Spacer()
        }
        .padding()
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .background(Color("background"))
        .navigationBarHidden(true)
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
            .environmentObject(ImageExamManager())
    }
}
