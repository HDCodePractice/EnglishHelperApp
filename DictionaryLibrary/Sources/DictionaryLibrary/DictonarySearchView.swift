//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-03-08.
//

import SwiftUI
import CommomLibrary

public struct DictonarySearchView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var searchText = ""
    
    public init(){}
    public var body: some View {
        FilteredList(
            sortDescriptors: [
                NSSortDescriptor(
                    key: "name",
                    ascending: true,
                    selector: #selector(NSString.localizedStandardCompare(_:))
                )
            ],
            predicate: NSPredicate(format: "name LIKE[c] %@", "*\(searchText)*")
            //                predicate: NSPredicate(format: "name CONTAINS %@", searchText)
        ){ (item:Word) in
            let item = item.viewModel
            Text("\(item.name)")
        }
        .environment(\.managedObjectContext,viewContext)
        .navigationTitle("Words")
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Look up for dictonary"
        )
        
    }
}

struct DictonarySearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DictonarySearchView()
                .environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
        }
    }
}
