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
                    vm.goToNextQuestion()
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
    @StateObject static var vm = PictureGameViewModel()
    
    static var previews: some View {
        NavigationView{
            PictureGameProgressView()
                .environmentObject(vm)
        }
    }
}
