//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-03-08.
//

import SwiftUI
import CommomLibrary

struct DictonarySearchView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    
    let names = ["Holly", "Josh", "Rhonda", "Ted"]
    
    var body: some View {
        NavigationView {
            FilteredList{ (item:Word) in
                let item = item.viewModel
                Text("\(item.name)")
            }
            .environment(\.managedObjectContext,viewContext)
            .navigationTitle("Words")
        }
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return names
        } else {
            return names.filter { $0.contains(searchText) }
        }
    }
}

struct DictonarySearchView_Previews: PreviewProvider {
    static var previews: some View {
        DictonarySearchView()
            .environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
    }
}
