//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-01-15.
//

import SwiftUI

struct ImportDictItemView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var vm : ImportDictViewModel
    var dictName : String
    @State var showingAlert = false
    
    var body: some View {
        VStack {
            Spacer()
            Text(dictName)
            Spacer()
            Button(role:.destructive){
                showingAlert = true
            }label: {
                Text("Delete")
            }
            Spacer()
        }
        .alert("Delete \(dictName)?", isPresented: $showingAlert) {
            Button("OK", role: .destructive) {
                vm.dictName = dictName
                vm.cleanDict()
                vm.checkLocalDictList()
                self.mode.wrappedValue.dismiss()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

struct ImportDictItemView_Previews: PreviewProvider {
    static var previews: some View {
        ImportDictItemView(dictName: "hello")
            .environmentObject(ImportDictViewModel())
    }
}
