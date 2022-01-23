//
//  PictureGameQuestionView.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-20.
//

import SwiftUI
import TranslateController

struct PictureGameQuestionView: View {
    @EnvironmentObject var vm : PictureGameViewModel
    @State var text = ""
    @State var show_translate = false
    
    var body: some View {
        VStack(spacing: 20){
            HStack{
                Text("Picture Game")
                    .liacTitle()
                Spacer()
                Text("\(vm.index) out of \(vm.length)")
                    .foregroundColor(Color("AccentColor"))
                    .fontWeight(.heavy)
            }
            ProgressBar(
                length: vm.length,
                index: vm.index
            )
            VStack(){
                Text("Tap the answer of")
                    .font(.subheadline.weight(.heavy))
                    .foregroundColor(.gray)
                HStack{
                    Spacer()
                    Text(vm.question)
                        .lineLimit(1)
                        .font(.largeTitle.weight(.heavy))
                        .minimumScaleFactor(0.01)
                    Spacer()
                    TranslateController(text: $text, showing: $show_translate)
                        .frame(width: 0, height: 0)
                    Button(){
                        text = "Which is \(vm.question)?"
                        show_translate = true
                    }label: {
                        Image(systemName: "questionmark.circle")
                            .font(.title2)
                    }
                }
                VStack(spacing: 20){
                    ForEach(vm.answerChoices){ answer in
                        AnswerRow(answer: answer)
                            .environmentObject(vm)
                    }
                }
            }
            Button{
                vm.goToNextQuestion()
            }label: {
                PrimaryButton(
                    text: "Next",
                    background: vm.answerSelected ? Color("AccentColor") : Color(.gray)
                )
            }
            .disabled(!vm.answerSelected)
            Spacer()
        }
        .padding()
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .navigationBarHidden(true)
    }
}

struct PictureGameQuestionView_Previews: PreviewProvider {
    @StateObject static var vm = PictureGameViewModel()
    
    static var previews: some View {
        PictureGameQuestionView()
            .environmentObject(vm)
            .onAppear(){
                Task{
                    await vm.loadData()
                }
            }
    }
}

