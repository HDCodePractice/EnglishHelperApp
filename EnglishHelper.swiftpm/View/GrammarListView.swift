//
//  File.swift
//  EnglishHelper
//
//  Created by 老房东 on 2021/12/19.
//

import SwiftUI

struct GrammarListView: View {
    
    var body: some View {
        NavigationView{
            List(grammars, id: \.name){ grammar in
                NavigationLink(grammar.name){
                    WebView(url: grammar.url)
                }
            }
            .navigationTitle("Grammar Book")
        }
    }
}
