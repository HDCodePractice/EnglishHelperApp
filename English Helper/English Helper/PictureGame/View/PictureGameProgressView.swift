//
//  PictureGameProgressView.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-20.
//

import SwiftUI

struct PictureGameProgressView: View {
    @EnvironmentObject var vm : PictureGameViewModel
    
    var body: some View {
        if vm.reachedEnd {
            VStack(spacing:20){
                Text("Words Game")
                    .liacTitle()
                Text("Congratulations, you completed the game!")
                
                Text("You scored \(vm.score) out of \(vm.length)")
                
                Button{
                    vm.generatePictureExam()
                }label: {
                    PrimaryButton(text: "Play again")
                }
            }
            .foregroundColor(Color("AccentColor"))
            .padding()
            .frame(maxWidth:.infinity,maxHeight: .infinity)
        }else{
            PictureGameQuestionView()
                .environmentObject(vm)
        }
    }
}

struct PictureGameProgressView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = PictureGameViewModel()
        vm.mokeData()
        Task{
            await vm.loadData()
        }
        return NavigationView{
            PictureGameProgressView()
                .environmentObject(vm)
        }
    }
}
