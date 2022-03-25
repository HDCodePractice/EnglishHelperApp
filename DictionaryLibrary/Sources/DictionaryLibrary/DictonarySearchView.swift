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
        
    var body: some View {
        NavigationView {
            FilteredList(
//                predicate: NSPredicate(format: "name LIKE %@", "*\(searchText)*")
                predicate: NSPredicate(format: "name CONTAINS %@", searchText)
            ){ (item:Word) in
                let item = item.viewModel
                Text("\(item.name)")
            }
            .environment(\.managedObjectContext,viewContext)
            .navigationTitle("Words")
            .searchable(text: $searchText, prompt: "Look up for dictonary")
        }
    }
    
}

struct DictonarySearchView_Previews: PreviewProvider {
    static var previews: some View {
        DictonarySearchView()
            .environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
    }
}
