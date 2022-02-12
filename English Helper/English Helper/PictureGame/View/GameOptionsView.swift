//
//  GameOptionsView.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-11.
//

import SwiftUI

struct GameOptionsView: View {
    @EnvironmentObject var vm : PictureGameViewModel
    @State private var showingSheet : Bool = false

    var body: some View {
        VStack{
            Text("")
            Text("Max number of games:\(vm.length)")
                .foregroundColor(Color("AccentColor"))
            Slider(value: .init(get: {Double(vm.length)}, set: {vm.length = Int($0)}),
                in: 10...100,
                step: 10,
                minimumValueLabel: Text("10"),
                maximumValueLabel: Text("100"),
                label: {}
            )
            VStack{
                Text("Select Mode")
                EnumPicker(selected: $vm.gameMode, title: "Select Mode:")
                    .pickerStyle(.segmented)

            }
            Spacer()
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
}

struct GameOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        GameOptionsView()
            .environmentObject(PictureGameViewModel())
    }
}
