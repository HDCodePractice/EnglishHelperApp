//
//  PictureGameProgressView.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-20.
//

import SwiftUI
import CommomLibrary
import ActivityView
import TranslateView

struct PictureGameProgressView: View {
    @EnvironmentObject var vm : PictureGameViewModel
    @State var text : String?
    @State private var item : ActivityItem?
    
    var body: some View {
        VStack(spacing: 20){
            HStack{
                Button(){
                    vm.gameStatus = .start
                }label: {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.accent)
                    Text("Picture Game")
                        .foregroundColor(.accent)
                        .fontWeight(.heavy)
                }
                
                Spacer()
                Text("\(vm.index) out of \(vm.length)")
                    .foregroundColor(.accent)
                    .fontWeight(.heavy)
                Button{
                    let scenes = UIApplication.shared.connectedScenes
                    if let windowScenes = scenes.first as? UIWindowScene,let window = windowScenes.windows.first{
                        var answers = ""
                        var answerCount = 1
                        for a in vm.answerChoices{
                            answers += "\(answerCount).\(a.filePath)\n"
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
                    background: vm.answerSelected ? .accent : .gray
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

struct PictureGameProgressView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = PictureGameViewModel(isPreview: true)
        vm.generatePictureExam()
        return NavigationView{
            PictureGameProgressView()
                .environmentObject(vm)
        }
    }
}