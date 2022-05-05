//
//  SwiftUIView.swift
//
//
//  Created by 老房东 on 2022-03-08.
//

import SwiftUI
import CommomLibrary
import RealmSwift

struct DictonarySearchView: View {
    @EnvironmentObject var vm : DictonarySearchViewModel
    @ObservedResults(Topic.self) var topics
    @ObservedResults(Word.self) var words
    
    @State private var isLoading = false
    @State private var searchFilter = ""
    @State private var selectedTopic = ""
    @State private var showSelectTopicSheet : Bool = false
    
    public var body: some View {
        List{
            ForEach(topics.where({
                var filter = $0.name.like(selectedTopic.isEmpty ? "*" : selectedTopic)
                if !searchFilter.isEmpty {
                    filter = filter && $0.pictures.words.name.contains(searchFilter, options: .caseInsensitive)
                }
                if vm.isOnlyShowNewWord{
                    filter = filter && $0.pictures.words.isNew == true
                }
                return filter
            }).sorted(byKeyPath: "name")){ topic in
                Section(topic.name){
                    ForEach(words.where({
                        var filter = $0.assignee.assignee.name==topic.name
                        if !searchFilter.isEmpty{
                            filter = filter && $0.name.contains(searchFilter, options: .caseInsensitive)
                        }
                        if vm.isOnlyShowNewWord{
                            filter = filter && $0.isNew==true
                        }
                        return filter
                    }).sorted(byKeyPath: "name")){ word in
                        WordListItemView(word: word)
                    }
                }
            }
        }
        .navigationTitle("Dictionary")
        .searchable(
            text: $searchFilter,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Lookup Dictionary"
        )
        .disableAutocorrection(true)
        .toolbar {           
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 0){
                    Button {
                        Task{
                            isLoading = true
                            await vm.fetchData()
                            isLoading = false
                        }
                    } label: {
                        if isLoading{
                            ProgressView()
                        }else{
                            Image(systemName: "arrow.clockwise.circle")
                        }
                    }
                    .disabled(isLoading)
                    
                    Button{
                        vm.isOnlyShowNewWord.toggle()
                    }label:{
                        if vm.isOnlyShowNewWord{
                            Image(systemName: "newspaper.circle.fill")
                        }else{
                            Image(systemName: "newspaper.circle")
                        }
                    }
                    
                    Button {
                        showSelectTopicSheet = true
                    } label: {
                        if selectedTopic.isEmpty {
                            Image(systemName: "gearshape.circle")
                        }else{
                            Image(systemName: "gearshape.circle.fill")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showSelectTopicSheet) {
            NavigationView{
                ChooseTopicView(selectedTopic: $selectedTopic)
            }
        }
    }
}

public struct DictonarySearchMainView: View {
    @StateObject var vm = DictonarySearchViewModel()
    
    public init(){}
    
    public var body: some View {
        DictonarySearchView()
            .environmentObject(vm)
    }
}

struct DictonarySearchView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = RealmController.preview
        let vm = DictonarySearchViewModel()
        return NavigationView {
            DictonarySearchView()
                .environmentObject(vm)
        }
    }
}
