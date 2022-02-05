//
//  PictureGame.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-20.
//

import SwiftUI

struct PictureGame: View {
    @StateObject var vm = PictureGameViewModel()
    @State private var action: Int? = 0
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
            VStack(spacing:20){
                Text("Picture Game")
                    .liacTitle()
                Text("Are you ready to test out English words?")
                    .foregroundColor(Color("AccentColor"))
            }
            VStack{
                HStack{
                    Text("Number of games:\(vm.length)")
                        .foregroundColor(Color("AccentColor"))
                    Spacer()
                }
                Slider(value: .init(get: {Double(vm.length)}, set: {vm.length = Int($0)}),
                    in: 10...100,
                    step: 10,
                    minimumValueLabel: Text("10"),
                    maximumValueLabel: Text("100"),
                    label: {
                        Text("Rating")
                    }
                )
            }.padding(.horizontal)
            
            PrimaryButton(
                text: vm.loadFinished ? "Let't go!" : "Load Data...",
                background: vm.loadFinished ? Color("AccentColor") : .secondary
            ).onTapGesture(){
                vm.generatePictureExam()
            }
            .disabled(vm.loadFinished ? false : true)
            Text("Select Topics")
                .onTapGesture {
                    showingSheet = true
                }
                .sheet(isPresented: $showingSheet){
                    NavigationView{
                        ListTopicView()
                    }
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
        let vm = PictureGameViewModel()
        vm.mokeData()
        vm.startExam = false
        return NavigationView{
            PictureGame(vm: vm)
                .navigationViewStyle(.stack)
        }
    }
}
