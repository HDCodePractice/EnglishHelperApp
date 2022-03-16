//
//  PictureGameQuestionView.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-20.
//

import SwiftUI
import TranslateView
import ActivityView
import CommomLibrary

struct PictureGameQuestionView: View {
    @EnvironmentObject var vm : PictureGameViewModel
    @State var text : String?
    @State private var item : ActivityItem?

    
    var body: some View {
        VStack(spacing: 20){
            HStack{
                Button(){
                    vm.startExam = false
                }label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(Color("AccentColor"))
                    Text("Picture Game")
                        .foregroundColor(Color("AccentColor"))
                        .fontWeight(.heavy)
                }

                Spacer()
                Text("\(vm.index) out of \(vm.length)")
                    .foregroundColor(Color("AccentColor"))
                    .fontWeight(.heavy)
                Button{
                    let scenes = UIApplication.shared.connectedScenes
                    if let windowScenes = scenes.first as? UIWindowScene,let window = windowScenes.windows.first{
                        var answers = ""
                        var answerCount = 1
                        for a in vm.answerChoices{
                            answers += "\(answerCount).\(a.topic) \(a.chapter) \(a.name)\n"
                            answerCount += 1
                        }
                        item =  ActivityItem(items: window.asImage(),answers)
                    }
                }label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .activitySheet($item)
            }
            ProgressBar(
                length: vm.length,
                index: vm.index
            )
            VStack(){
                HStack{
                    Spacer()
                    Text("Tap the answer of")
                        .font(.subheadline.weight(.heavy))
                        .foregroundColor(.gray)
                    Spacer()
                    PlayAudio(url: vm.audioFile,isAutoPlay: vm.isAutoPronounce)
                    Button(){
                        text = "Which is \(vm.question)?"
                    }label: {
                        Image(systemName: "questionmark.circle")
                            .font(.title2)
                    }.translateSheet($text)
                }
                Text(vm.question)
                    .lineLimit(1)
                    .font(.largeTitle.weight(.heavy))
                    .minimumScaleFactor(0.01)
                AnswerGrid()
                    .environmentObject(vm)
            }
            Button{
                vm.goToNextQuestion()
            }label: {
                PrimaryButton(
                    "Next",
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
    static var previews: some View {
        let vm = PictureGameViewModel()
        vm.mokeData()
        return PictureGameQuestionView()
            .environmentObject(vm)
    }
}

