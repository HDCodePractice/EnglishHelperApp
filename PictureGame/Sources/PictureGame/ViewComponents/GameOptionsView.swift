//
//  GameOptionsView.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-11.
//

import SwiftUI
import CommomLibrary

struct GameOptionsView: View {
    @EnvironmentObject var vm : PictureGameViewModel
    @State private var showingSheet : Bool = false
    
    var body: some View {
        let gameMode_bind = Binding {
            vm.gameMode
        } set: {
            vm.setGameMode(mode: $0)
        }
        
        let showingSheet_bind = Binding{
            showingSheet
        } set: {
            showingSheet = $0
            vm.setGameMode(mode: vm.gameMode)
        }

        VStack{
            Text("Number of Vocabulary: \(vm.length)")
                .foregroundColor(.accent)
            VStack{
//                Text("Select Mode")
                EnumPicker(selected: gameMode_bind, title: "Select Mode:")
                    .pickerStyle(.segmented)
                
            }
            Toggle("Auto Pronounce", isOn: $vm.isAutoPronounce)
            Spacer()
            Text("Select Topics")
                .onTapGesture {
                    showingSheet = true
                }
                .sheet(isPresented: showingSheet_bind){
                    NavigationView{
                        SelectTopicsView()
                    }
                }
            Text("")
            Text("")
        }.padding(.horizontal)
    }
}

struct GameOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        GameOptionsView()
            .environmentObject(PictureGameViewModel())
    }
}
