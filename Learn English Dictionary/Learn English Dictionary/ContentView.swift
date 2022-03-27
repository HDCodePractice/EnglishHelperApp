//
//  ContentView.swift
//  Learn English Dictionary
//
//  Created by 老房东 on 2022-03-26.
//

import SwiftUI
import DictionaryLibrary
import CommomLibrary

struct ContentView: View {
    var body: some View {
        NavigationView{
            DictonarySearchView()
                .environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
