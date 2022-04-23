//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-04-22.
//

import SwiftUI
import CommomLibrary

struct DictonarySearchOptionView: View {
    @EnvironmentObject var vm : DictonarySearchViewModel
    @State var isCleanAllNew = false
    @State var isMakeAllToNew = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List{
            Section("New Word") {
                HStack{
                    Button("Clean All New") {
                        Task{
                            isCleanAllNew = true
                            await vm.cleanAllNew()
                            isCleanAllNew = false
                            print("finish clean")
                        }
                    }
                    if isCleanAllNew{
                        ProgressView()
                    }
                }
                HStack{
                    Button("Make All to New") {
                        Task{
                            isMakeAllToNew = true
                            await vm.makeAllToNew()
                            isMakeAllToNew = false
                            print("finish clean")
                        }
                    }
                    if isMakeAllToNew{
                        ProgressView()
                    }
                }
                HStack{
                    Toggle("Only Show New", isOn: $vm.isOnlyShowNewWord)
                }
            }
            .navigationBarTitle("Search Option")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(){
                    dismiss()
                }label: {
                    Text("Done").fontWeight(.semibold)
                }
            }
        }
    }
    
    struct DictonarySearchOptionView_Previews: PreviewProvider {
        static var previews: some View {
            let _ = RealmController.preview
            let vm = DictonarySearchViewModel(isPreview: true)
            return NavigationView{
                DictonarySearchOptionView()
                    .environmentObject(vm)
            }
        }
    }
}
