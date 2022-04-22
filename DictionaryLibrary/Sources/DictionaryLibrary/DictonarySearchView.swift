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
                searchFilter.isEmpty ? $0.name.like(selectedTopic.isEmpty ? "*" : selectedTopic) : $0.name.like(selectedTopic.isEmpty ? "*" : selectedTopic) && $0.pictures.words.name.contains(searchFilter, options: .caseInsensitive)}).sorted(byKeyPath: "name")){ topic in
                    Section(topic.name){
                        if searchFilter.isEmpty{
                            ForEach(words.where({$0.assignee.assignee.name==topic.name}).sorted(byKeyPath: "name")){ word in
                                NavigationLink{
                                    WordDetailView(item: word)
                                }label: {
                                    HStack{
                                        PictureView(url: URL(string: word.pictureUrl.urlEncoded()))
                                            .frame(width: 60, height: 60)
                                            .shadow(radius: 10)
                                        VStack(alignment:.leading){
                                            Text(word.name)
                                        }
                                    }
                                }
                            }
                        }else{
                            ForEach(words.where({$0.assignee.assignee.name==topic.name && $0.name.contains(searchFilter, options: .caseInsensitive)}).sorted(byKeyPath: "name")){ word in
                                NavigationLink{
                                    WordDetailView(item: word)
                                }label: {
                                    HStack{
                                        PictureView(url: URL(string: word.pictureUrl.urlEncoded()))
                                            .frame(width: 60, height: 60)
                                            .shadow(radius: 10)
                                        VStack(alignment:.leading){
                                            Text(word.name)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
        }
        .navigationTitle("Words")
        .searchable(
            text: $searchFilter,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Look up for dictonary"
        )
        .disableAutocorrection(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
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
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showSelectTopicSheet = true
                } label: {
                    if selectedTopic.isEmpty {
                        Image(systemName: "lock.circle")
                    }else{
                        Image(systemName: "lock.circle.fill")
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
