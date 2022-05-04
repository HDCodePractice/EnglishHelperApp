//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-05-04.
//

import SwiftUI

public struct MainSettingView: View{
    public init(){}
    
    public var body: some View{
        SettingView()
            .environmentObject(SettingViewModel())
    }
}

struct SettingView: View {
    @EnvironmentObject var vm : SettingViewModel
    @State var isCleanAllNew = false
    @State var isMakeAllToNew = false
    
    var body: some View {
        List{
            Section("Sync Option") {
                HStack{
                    Text("Clean All New")
                    Spacer()
                    if isCleanAllNew{
                        ProgressView()
                    }
                }
                .onTapGesture {
                    Task{
                        if isCleanAllNew == false{
                            isCleanAllNew = true
                            await vm.cleanAllNew()
                            try! await Task.sleep(seconds: 1)
                            isCleanAllNew = false
                        }
                    }
                }
                
                HStack{
                    Text("Make All to New")
                    Spacer()
                    if isMakeAllToNew{
                        ProgressView()
                    }
                }
                .onTapGesture {
                    Task{
                        if isMakeAllToNew == false{
                            isMakeAllToNew = true
                            await vm.makeAllToNew()
                            try! await Task.sleep(seconds: 1)
                            isMakeAllToNew = false
                        }
                    }
                }
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = SettingViewModel(isPreview: true)
        
        return SettingView()
            .environmentObject(vm)
    }
}
