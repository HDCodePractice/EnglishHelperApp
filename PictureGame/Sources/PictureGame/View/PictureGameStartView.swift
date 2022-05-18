//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-04-26.
//

import SwiftUI
import CommomLibrary
import RealmSwift

struct PictureGameStartView: View {
    @EnvironmentObject var vm : PictureGameViewModel
    @ObservedResults(Word.self) var words
    @State var isLoadFinished = true
    
    var body: some View {
        VStack(spacing:40){
            VStack(spacing:20){
                Text("Picture Game")
                    .liacTitle()
                Text("Are you ready to test out English words?")
                    .foregroundColor(.accent)
                    .multilineTextAlignment(.center)
            }
            if !isLoadFinished {
                HStack{
                    Text("Sync Data...")
                    ProgressView()
                }
                .onAppear {
                    Task{
                        await vm.fetchData()
                        try! await Task.sleep(seconds: 3)
                        isLoadFinished = true
                    }
                }
            }else{
                PrimaryButton("Let's go!",background: .accent)
                    .onTapGesture{
                        withAnimation {
                            vm.generatePictureExam()
                        }
                    }
            }
            GameOptionsView()
                .environmentObject(vm)
        }
        .padding()
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        //        .edgesIgnoringSafeArea(.all)
    }
}

struct PictureGameStartView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = PictureGameViewModel(isPreview: true)
        return PictureGameStartView()
            .environmentObject(vm)
    }
}
