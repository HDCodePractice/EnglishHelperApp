//
//  LearnEnglishHelperAppApp.swift
//  LearnEnglishHelperApp
//
//  Created by 老房东 on 2022-02-22.
//

import SwiftUI

@main
struct LearnEnglishHelperAppApp: App {
    @StateObject var vm = LearnEnglishHelperViewModel()
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)
        }
        .onChange(of: scenePhase) { phase in
            switch phase{
            case .active:
                print("app active")
                Task{
                    if vm.isLoading == false{
                        await vm.fetchData()
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
