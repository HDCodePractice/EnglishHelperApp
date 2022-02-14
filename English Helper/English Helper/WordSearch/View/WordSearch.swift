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
    
    var body: some View {
        VStack{
            if begin{
                WordListGrid()
                    .environmentObject(vm)
            }else{
                Button{
                    begin.toggle()
                }label: {
                    Text("Start Game")
                }
            }
        }
//        .navigationBarTitle("")
    }
}

struct WordSearch_Previews: PreviewProvider {
    static var previews: some View {
        WordSearch()
    }
}
