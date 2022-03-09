//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-03-09.
//
import CoreData
import SwiftUI

struct FilteredList<T: NSManagedObject,Content: View>: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var fetchRequest: FetchedResults<T>
    let content: (T) -> Content
    
    var body: some View {
        List {
            ForEach(fetchRequest, id:\.self) { item in
                self.content(item)
            }
            .onDelete(perform: deleteItems)
        }
    }
    
    init(predicate: NSPredicate? = nil, @ViewBuilder content: @escaping (T) -> Content){
        _fetchRequest = FetchRequest<T>(
            sortDescriptors: [],
            predicate: predicate,
            animation: .default)
        self.content = content
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { fetchRequest[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

struct FilteredList_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            FilteredList(predicate: NSPredicate(format: "%K BEGINSWITH %@", "name", "C")){ (item:Chapter) in
                let item = item.viewModel
                Text("\(item.name)")
            }.environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
            FilteredList{ (item:Word) in
                let item = item.viewModel
                Text("\(item.name)")
            }.environment(\.managedObjectContext,PersistenceController.preview.container.viewContext)
        }
    }
}
