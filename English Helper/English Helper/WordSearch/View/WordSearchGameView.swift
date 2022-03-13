//
//  WordSearchGameView.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-14.
//

import SwiftUI
import CommomLibrary

struct WordSearchGameView: View {
    @EnvironmentObject var vm : WordSearchViewModel
    
    var body: some View {
        VStack{
            HStack{
                ForEach (vm.words){ word in
                    WordCellView(wordCell: word)
                }
            }
            ZStack(alignment: .top){
                Text(vm.selectedWord)
                    .background(vm.tempLine?.color)
                WordListGrid()
                    .padding()
                    .environmentObject(vm)
            }
            
            PrimaryButton("restart")
                .padding()
                .onTapGesture {
                    vm.startGame()
                }
        }
    }
}

struct WordSearchGameView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = WordSearchViewModel()
        vm.startGame()
        vm.selectedWord = "TestSelect"
        return WordSearchGameView()
            .environmentObject(vm)
    }
}
