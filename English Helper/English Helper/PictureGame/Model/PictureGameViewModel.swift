//
//  PictureGameViewModel.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-21.
//

import Foundation
import SwiftUI

class PictureGameViewModel: ObservableObject{
    private var manager = PictureDictionaryManager.instance
    private var realmManager = RealmManager.instance
    private var chapters = [LocalChapter]()
    private var pictureExam : [PictureExam.Result] = []
    private let answerLength = 6
    
    @Published private(set) var loadFinished : Bool = false
    @Published private(set) var question : String = ""
    @Published private(set) var answerChoices: [Answer] = []
    @Published private(set) var reachedEnd = false
    
    @Published var answerSelected = false
    @Published private(set) var index = 0
    @Published private(set) var score = 0
    
    @Published var length = 10
    @Published var startExam = false
    @Published var gameMode = GameMode.finish
    
    init(){}
    
    enum GameMode: String, CaseIterable {
        case uniq = "Uniq"
        case random = "Random"
        case finish = "Finish"
    }
    
    @MainActor
    func loadData() async{
        await manager.fromServerJsonToRealm()
        chapters = realmManager.getAllChapters()

        if manager.chapters.count == 0{
            loadFinished = false
        }else{
            loadFinished = true
        }
    }
    
    func generatePictureExam(){
        realmManager.genExamRealm()
        
        switch gameMode {
        case .uniq:
            if realmManager.memoRealmWordCount < length{
                length = realmManager.memoRealmWordCount
            }
        case .random:
            // 不做任何事
            length = length
        case .finish:
            length = realmManager.memoRealmWordCount
        }
        
        if length == 0 {
            return
        }
        reachedEnd = false
        index = 0
        score = 0
        
        setQuestion()
        startExam = true
    }
    
    func goToNextQuestion(){
        switch gameMode {
        case .uniq,.random:
            if index+1 < length{
                // 在random和uniq模式下，做完一题index就多一步
                // finish模式的index增涨是必须答对
                index += 1
                setQuestion()
            }else{
                reachedEnd = true
            }
        case .finish:
            if index < length{
                setQuestion()
            }else{
                reachedEnd = true
            }
        }
    }
    
    func setQuestion(){
        if index < length{
            var currentQuestion : PictureExam.Result?
            switch gameMode {
            case .uniq:
                currentQuestion = realmManager.getUniqExam(answerLength: answerLength)
            case .random:
                currentQuestion = realmManager.getRandomExam(answerLength: answerLength)
            case .finish:
                currentQuestion = realmManager.getRandomExam(answerLength: answerLength)
            }
            if let currentQuestion = currentQuestion {
                question = currentQuestion.questionWord
                answerChoices = currentQuestion.questAnswers
            }
        }
        answerSelected = false
    }
    
    func selectAnswer(answer: Answer){
        answerSelected = true
        if answer.isCorrect {
            score += 1
            if gameMode == .finish{
                // 如果是finish模式，把答对的word从memoRealm中清除
                realmManager.deleteMemoRealmWord(word: question, pictureFileName: answer.name)
                index += 1
            }
        }
    }
    
    func mokeData(resetData:Bool=false){
        if let d: [Chapter] = load("example_picture.json"){
            manager.chapters = d
        }else{
            manager.chapters = []
        }
        if resetData{
            realmManager.cleanRealm()
        }
        realmManager.syncFromServer(chapters: manager.chapters)
        chapters = realmManager.getAllChapters()
        loadFinished = true
        generatePictureExam()
        reachedEnd = true
    }
    
    func toggleChapter(name: String){
        if let cindex = chapters.firstIndex(where: {$0.name == name}){
            chapters[cindex].isSelect.toggle()
            
            if chapters[cindex].isSelect {
                for tindex in 0..<chapters[cindex].topics.count {
                    chapters[cindex].topics[tindex].isSelect = true
                }
            }else{
                for tindex in 0..<chapters[cindex].topics.count {
                    chapters[cindex].topics[tindex].isSelect = false
                }
            }
        }
    }
    
    func toggleTopic(name: String,chaptername: String){
        if let cindex = chapters.firstIndex(where: {$0.name == chaptername}){
            if let tindex = chapters[cindex].topics.firstIndex(where: {$0.name == name}){
                chapters[cindex].topics[tindex].isSelect.toggle()
                // 如果chapter没选，顺便选上
                if chapters[cindex].topics[tindex].isSelect && !chapters[cindex].isSelect{
                    chapters[cindex].isSelect = true
                    return
                }
                
                // 如果chapter选上了，查看是不是所有的都是没选中的，如果都没选，chapter也取消选择
                if chapters[cindex].isSelect{
                    for t in chapters[cindex].topics{
                        if t.isSelect{
                            return
                        }
                    }
                    // 所有子项都没选择，把chapter也取消选择
                    chapters[cindex].isSelect = false
                }
            }
        }
    }
}
