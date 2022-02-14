//
//  PictureGame.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-20.
//

import SwiftUI

struct PictureGame: View {
    @StateObject var vm = PictureGameViewModel()
    @State private var showingSheet : Bool = false
    
    var body: some View {
        if vm.startExam{
            PictureGameProgressView()
                .environmentObject(vm)
        }else{
            startBody
        }
    }
    
    var startBody: some View{
        VStack(spacing:40){
            Spacer()
            VStack(spacing:20){
                Text("Picture Game")
                    .liacTitle()
                Text("Are you ready to test out English words?")
                    .foregroundColor(Color("AccentColor"))
            }
            PrimaryButton(
                text: vm.loadFinished ? "Let't go!" : "Load Data...",
                background: vm.loadFinished ? Color("AccentColor") : .secondary
            ).onTapGesture(){
                vm.generatePictureExam()
            }
            .disabled(vm.loadFinished ? false : true)
            GameOptionsView()
                .environmentObject(vm)
        }
        .padding()
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .task {
            await vm.loadData()
        }
    }
}

struct PictureGame_Previews: PreviewProvider {
    static var previews: some View {
        let vm = PictureGameViewModel()
        vm.mokeData()
        vm.startExam = false
        return NavigationView{
            PictureGame(vm: vm)
                .navigationViewStyle(.stack)
        }
    }
}
