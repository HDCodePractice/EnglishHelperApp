//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-03-08.
//

import SwiftUI
import CommomLibrary

public struct DictonarySearchView: View {
    @StateObject private var vm = DictonarySearchViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var searchText = ""
    var query: Binding<String>{
        Binding{
            searchText
        }set:{ newValue in
            searchText = newValue
            items.nsPredicate = newValue.isEmpty
            ? nil
            : NSPredicate(format: "name CONTAINS[c] %@", newValue)
        }
    }
    
    public init(){}
    
    @SectionedFetchRequest<String,Word>(
        sectionIdentifier: \.topicSection,
        sortDescriptors: [
            SortDescriptor(\.picture?.topic?.name),
            SortDescriptor(\.name)
        ]
    )
    private var items: SectionedFetchResults<String,Word>

    func FilterView() -> some View {
        return List{
            ForEach(items){section in
                Section(header: Text(section.id)){
                    ForEach(section){ item in
                        NavigationLink {
                            WordDetailView(item: item)
                        } label: {
                            HStack{
                                PictureView(url: URL(string: item.viewModel.pictureUrl))
                                    .frame(width: 60, height: 60)
                                    .shadow(radius: 10)
                                VStack(alignment:.leading){
                                    Text("\(item.viewModel.name)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    

    
//    @FetchRequest<Word>(sortDescriptors: [
//        SortDescriptor(\.picture?.topic?.name),
//        SortDescriptor(\.name)
//    ],animation: .default)
//    private var items: FetchedResults<Word>
//
//    func FilterView() -> some View {
//        return List{
//            ForEach(items){item in
//                NavigationLink {
//                    WordDetailView(item: item)
//                } label: {
//                    HStack{
//                        PictureView(url: URL(string: item.viewModel.pictureUrl))
//                            .frame(width: 60, height: 60)
//                            .shadow(radius: 10)
//                        VStack(alignment:.leading){
//                            Text("\(item.viewModel.name)")
//                            Text("\(item.viewModel.topicName)")
//                                .font(.footnote)
//                                .lineLimit(1)
//
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    public var body: some View {
        VStack{
            if vm.loadStatue == .load {
                ProgressView()
                    .onAppear {
                        vm.fetchData(viewContext: viewContext)
                    }
            }else{
                FilterView()
            }
        }
        .navigationTitle(vm.loadStatue == .load ? "Syncing Words..." : "Words")
        //        .navigationBarTitleDisplayMode(.inline)
        .searchable(
            text: query,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Look up for dictonary"
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    vm.loadStatue = .load
                } label: {
                    Image(systemName: "arrow.clockwise.circle")
                }
                
            }
        }
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
