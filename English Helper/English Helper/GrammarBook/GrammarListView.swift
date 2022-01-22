//
//  GrammarListView.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-19.
//

import SwiftUI

struct GrammarListView: View {
    @StateObject var vm = GrammarListViewModel()
    
    var body: some View {
        VStack{
            List(vm.grammars, id: \.name){ grammar in
                NavigationLink(grammar.name){
                    WebView(url: grammar.url)
                }
            }
        }
        .navigationTitle("Grammar Book")
        .task {
            vm.grammars = await vm.loadData()
        }
    }
}


struct GrammarListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            GrammarListView()
        }
    }
}
