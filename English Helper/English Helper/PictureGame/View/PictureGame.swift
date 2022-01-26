//
//  PictureGame.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-20.
//

import SwiftUI

struct PictureGame: View {
    @StateObject var vm = PictureGameViewModel()
    
    var body: some View {
        VStack(spacing:40){
            VStack(spacing:20){
                Text("Picture Game")
                    .liacTitle()
                Text("Are you ready to test out English words?")
                    .foregroundColor(Color("AccentColor"))
            }
            VStack(spacing:0){
                NavigationLink {
                    PictureGameProgressView()
                        .environmentObject(vm)
                }label: {
                    PrimaryButton(
                        text: vm.loadFinished ? "Let't go!" : "Load Data...",
                        background: vm.loadFinished ? Color("AccentColor") : .secondary
                    )
                }
                .disabled(vm.loadFinished ? false : true)
                ProgressBar(length: Int(vm.loadDataProgress*100), index: 100)
                    .padding(.horizontal)
                Text("\(Int(vm.loadDataProgress*100))%")
                    .foregroundColor(.secondary)
    
            }
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
        NavigationView{
            PictureGame()
                .navigationViewStyle(.stack)
        }
    }
}
