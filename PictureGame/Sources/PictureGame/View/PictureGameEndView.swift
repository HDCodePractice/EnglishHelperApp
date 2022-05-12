//
//  PictureGameEndView.swift
//  
//
//  Created by 老房东 on 2022-04-30.
//

import SwiftUI
import CommomLibrary

struct PictureGameEndView: View {
    @EnvironmentObject var vm : PictureGameViewModel
    
    var body: some View {
        VStack(spacing:20){
            Text("Picture Game")
                .liacTitle()
            Text("Congratulations, you completed the game!")
            
            Text("You scored \(vm.score) out of \(vm.length)")
            
            Button{
                vm.generatePictureExam()
            }label: {
                PrimaryButton("Play again")
            }
            GameOptionsView()
                .environmentObject(vm)
        }
        .foregroundColor(.accent)
        .padding()
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .navigationBarTitle("")
    }
}

struct PictureGameEndView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = PictureGameViewModel(isPreview: true)
        vm.generatePictureExam()
        return NavigationView{
            PictureGameEndView()
                .environmentObject(vm)
        }
    }
}
