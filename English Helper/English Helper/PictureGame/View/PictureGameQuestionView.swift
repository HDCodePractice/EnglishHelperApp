//
//  PictureGameQuestionView.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-20.
//

import SwiftUI
import TranslateController
import ActivityView

struct PictureGameQuestionView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var vm : PictureGameViewModel
    @State var text = ""
    @State var show_translate = false
    @State private var item : ActivityItem?
    
    var body: some View {
        VStack(spacing: 20){
            HStack{
                Button(){
                    mode.wrappedValue.dismiss()
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
                AnswerGrid()
                    .environmentObject(vm)
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
    static var previews: some View {
        let vm = PictureGameViewModel()
        vm.mokeData()
        Task{
            await vm.loadData()
        }
        return PictureGameQuestionView()
            .environmentObject(vm)
    }
}

