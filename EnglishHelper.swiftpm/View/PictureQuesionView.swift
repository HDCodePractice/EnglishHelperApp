//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-01-04.
//

import SwiftUI
import TranslateController

struct PictureQuesionView: View {
    @EnvironmentObject var pictureManager : PictureManager
    @State var show_translate = false
    @State var text = ""
    
    var body: some View {
        VStack(spacing:15){
            HStack{
                Text("Picture Game")
                    .liacTitle()
                Spacer()
                Text("\(pictureManager.index) out of \(pictureManager.length)")
                    .foregroundColor(Color("AccentColor"))
                    .fontWeight(.heavy)
            }
            ProgressBar(
                length: pictureManager.length,
                index: pictureManager.index
            )
            VStack(){
                Text("Tap the answer of")
                    .font(.subheadline.weight(.heavy))
                    .foregroundColor(.gray)
                HStack{
                    Spacer()
                    Text("\(pictureManager.question)")
                        .font(.title.weight(.heavy))
                        .foregroundColor(Color("primary"))
                        .multilineTextAlignment(.center)
                    Spacer()
                    TranslateController(text: $text, showing: $show_translate)
                        .frame(width: 0, height: 0)
                    Button(){
                        text = "Which is \(pictureManager.question)?"
                        show_translate = true
                    }label: {
                        Image(systemName: "figure.wave.circle")
                            .font(.title2)
                    }
                }
                PictureView(imageName: "\(pictureManager.pictureFilename)")
                    .border(.secondary)
            }
            VStack{
                HStack(){
                    Spacer()
                    ForEach(pictureManager.answerChoices){ answer in
                        AnswerButton(answer: answer)
                            .environmentObject(pictureManager)
                        Spacer()
                    }

//                    ForEach(0..<pictureManager.answerChoices.prefix(5).count,id:\.self){
//                        AnswerButton(answer: pictureManager.answerChoices[$0])
//                            .environmentObject(pictureManager)
//                    }
                }
//                if pictureManager.answerChoices.count>5{
//                    HStack{
//                        ForEach(5..<pictureManager.answerChoices.count,id:\.self){
//                            AnswerButton(answer: pictureManager.answerChoices[$0])
//                                .environmentObject(pictureManager)
//                        }
//                    }
//                }
            }
            Spacer()
            Button{
                pictureManager.goToNextQuestion()
            }label: {
                PrimaryButton(
                    text: "Next",
                    background: pictureManager.answerSelected ? Color("AccentColor") : Color(.gray)
                )
            }
            .disabled(!pictureManager.answerSelected)
        }
        .padding()
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .background(Color("background"))
        .navigationBarHidden(true)
    }
}

struct PictureQuesionView_Previews: PreviewProvider {
    static var previews: some View {
        PictureQuesionView()
            .environmentObject(PictureManager())
    }
}
