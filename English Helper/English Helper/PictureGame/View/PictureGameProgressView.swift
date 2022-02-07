//
//  PictureGameProgressView.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-20.
//

import SwiftUI

struct PictureGameProgressView: View {
    @EnvironmentObject var vm : PictureGameViewModel
    @State private var showingSheet : Bool = false
    
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
                
                VStack{
                    Text("")
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
                    HStack{
                        Toggle("Unique Words", isOn: $vm.isUniqExam)
                    }
                    Text("Select Topics")
                        .onTapGesture {
                            showingSheet = true
                        }
                        .sheet(isPresented: $showingSheet){
                            NavigationView{
                                ListTopicView()
                            }
                        }
                }.padding(.horizontal)
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
        return NavigationView{
            PictureGameProgressView()
                .environmentObject(vm)
        }
    }
}
