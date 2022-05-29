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
import AVKit
import RealmSwift

struct PictureGameProgressView: View {
    @EnvironmentObject var vm : PictureGameViewModel
    @State var text : String?
    @State private var item : ActivityItem?
    
    @State var player: AVPlayer?
    @ObservedResults(Word.self) var words
    
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
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
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
                    PlayAudio(url: vm.audioFile)
                    Button(){
                        text = "Which is \(vm.question)?"
                    }label: {
                        Image(systemName: "questionmark.circle")
                            .font(.title2)
                    }.translateSheet($text)
                    if let currentQuestion=vm.currentQuestion,let word = words.where({
                        $0.id==currentQuestion.id
                    }).first{
                        WordFavoriteButton(word: word,isButton: true)
                    }
                }
                HStack{
                    if let currentQuestion = vm.currentQuestion, currentQuestion.isNew{
                        Image(systemName: "circle.fill")
                            .font(.caption2)
                            .foregroundColor(.cyan)
                            .shadow(radius: 5)
                    }
                    Text(vm.question)
                        .lineLimit(1)
                        .font(.largeTitle.weight(.heavy))
                        .minimumScaleFactor(0.01)
                    CopyToClipboard(putString: vm.question)
                }
                AnswerGrid()
                    .environmentObject(vm)
            }
            Button{
                withAnimation {
                    vm.goToNextQuestion()
                }
                playAudio()
            }label: {
                PrimaryButton(
                    "Next",
                    background: vm.answerSelected ? .accent : .gray
                )
            }
            .disabled(!vm.answerSelected)
            Spacer()
        }
        .transition(.slide)
        .padding()
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .navigationBarHidden(true)
        .onAppear {
            playAudio()
        }
    }
    
    func playAudio(){
        if vm.isAutoPronounce{
            if let audioURL = URL(string: vm.audioFile){
                player = AVPlayer(url: audioURL)
                if let player=player{
                    player.play()
                }
            }
        }
    }
}

struct PictureGameProgressView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = PictureGameViewModel(isPreview: true)
        vm.generatePictureExam()
        vm.isAutoPronounce = true
        return NavigationView{
            PictureGameProgressView()
                .environmentObject(vm)
        }
    }
}
