//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-02-22.
//

import SwiftUI

enum GameMode: String, CaseIterable {
    case uniq = "Uniq"
    case random = "Random"
    case finish = "Finish"
}

struct EnumPickerDemoView: View {
    @State var gameMode = GameMode.finish
    var body: some View {
        VStack{
            Text("Select Mode")
            EnumPicker(selected: $gameMode, title: "Select Mode:")
                .pickerStyle(.segmented)

        }
    }
}

struct EnumPickerDemoView_Previews: PreviewProvider {
    static var previews: some View {
        EnumPickerDemoView()
            .environment(\.locale, .init(identifier: "en"))
        EnumPickerDemoView()
            .environment(\.locale, .init(identifier: "zh"))
    }
}
