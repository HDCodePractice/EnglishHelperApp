//
//  WordSearch.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-14.
//

import SwiftUI

struct WordSearch: View {
    @StateObject var vm : WordSearchViewModel = WordSearchViewModel()
    @State var begin : Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            HStack{
                Label("Back",systemImage: "chevron.backward")
                    .foregroundColor(.primary)
                    .onTapGesture {
                        dismiss()
                    }
                Spacer()
            }
            Spacer()
            if begin{
                WordSearchGameView()
                    .environmentObject(vm)
            }else{
                PrimaryButton(text: "Start Game")
                    .padding()
                    .onTapGesture {
                        begin.toggle()
                    }
            }
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

struct WordSearch_Previews: PreviewProvider {
    static var previews: some View {
        WordSearch()
    }
}
