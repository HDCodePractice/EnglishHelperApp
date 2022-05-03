//
//  LearnEnglishHelperAppApp.swift
//  LearnEnglishHelperApp
//
//  Created by 老房东 on 2022-02-22.
//

import SwiftUI

@main
struct LearnEnglishHelperAppApp: App {
    var vm : LearnEnglishHelperViewModel
    @Environment(\.scenePhase) var scenePhase
    
    init(){
        let v = LearnEnglishHelperViewModel()
        vm = v
        Task.init {
            v.isLoading = true
            await v.fetchData()
            v.isLoading = false
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
        }
        .onChange(of: scenePhase) { phase in
            switch phase{
            case .active:
                print("app active")
                Task.init {
                    if vm.isLoading == false{
                        vm.isLoading = true
                        await vm.fetchData()
                        vm.isLoading = false
                    }
                }
            case .inactive:
                print("app inactive")
            case .background:
                print("app background")
            default:
                print("app unknow status")
            }
        }
    }
}
