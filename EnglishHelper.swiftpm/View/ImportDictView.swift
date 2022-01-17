//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-01-10.
//

import SwiftUI

struct ImportDictView: View {
    @StateObject var vm = ImportDictViewModel()
    @State var showImporter = false
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    ForEach(vm.localDictList, id: \.self){ item in
                        NavigationLink(item){
                            ImportDictItemView(dictName: item)
                                .environmentObject(vm)
                        }
                    }
                }
                
                Section{
                    Button(){
                        showImporter = true
                    }label: {
                        Text("Import PictureDict")
                    }
                }
            }
            .fileImporter(isPresented: $showImporter, allowedContentTypes: [.zip]) { result in
                switch result {
                case .failure(let error):
                    vm.infoMessage = ("Error selecting file \(error.localizedDescription)")
                    showingAlert = true
                case .success(let url):
                    if url.startAccessingSecurityScopedResource() {
                        vm.importZIPFile(zipfile: url)
                        url.stopAccessingSecurityScopedResource()
                        vm.infoMessage += "\n Please restart the APP to apply the new dictionary data."
                        showingAlert = true
                    }
                }
            }
            .alert("\(vm.infoMessage)", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            }
        }
    }
}

struct ImportDictView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ImportDictView()
        }
    }
}
