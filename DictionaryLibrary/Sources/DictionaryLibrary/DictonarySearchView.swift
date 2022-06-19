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
    @ObservedResults(WordSelect.self) var wordSelects
    
    @State private var isLoading = false
    @State private var searchFilter = ""
    @State private var selectedTopic: [String] = []
    @State private var showSelectTopicSheet : Bool = false
    @State private var isShowFavorite : Bool = false
    
    var body: some View {
        let isNotNews: [String] = wordSelects.where{ $0.isNew==false && $0.isDeleted==false }.map{ $0.id }
        let isSelectedNews: [String] = wordSelects.where{ $0.isNew==true && $0.isDeleted==false }.map{ $0.id }
        let wordsList : [String] = words.map{ $0.id }
        let isNews = Array(Set(wordsList).subtracting(Set(isNotNews)).union(Set(isSelectedNews)))
        let isFavoriteds: [String] = wordSelects.where{ $0.isFavorited==true && $0.isDeleted==false }.map{ $0.id }
        VStack{
            List{
                if !searchFilter.isEmpty{
                    IrregularVerbItem(search: searchFilter.lowercased())
                    IrregularNounItem(search: searchFilter.lowercased())
                }
                ForEach(topics.where({
                    var filter = $0.name != ""
                    if !selectedTopic.isEmpty{
                        filter = $0.name.in(selectedTopic)
                    }
                    if !searchFilter.isEmpty {
                        filter = filter && $0.pictures.words.name.contains(searchFilter, options: .caseInsensitive)
                    }
                    if vm.isOnlyShowNewWord{
                        if isNotNews.count > 0 {
                            filter = filter && $0.pictures.words.id.in(isNews)
                        }
                    }
                    if isShowFavorite{
                        if isFavoriteds.count > 0{
                            filter = filter && $0.pictures.words.id.in(isFavoriteds)
                        }
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
                                if isNotNews.count > 0{
                                    filter = filter && !$0.id.in(isNotNews)
                                }
                            }
                            if isShowFavorite{
                                if isFavoriteds.count > 0{
                                    filter = filter && $0.id.in(isFavoriteds)
                                }
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
                            ZStack{
                                if vm.isOnlyShowNewWord{
                                    Image(systemName: "newspaper.circle.fill")
                                }else{
                                    Image(systemName: "newspaper.circle")
                                }
                            }.overlay {
                                if vm.isNewWords > 0{
                                    Color.cyan
                                        .overlay{
                                            let showNumber = vm.isNewWords > 99 ? "99+" : "\(vm.isNewWords)"
                                            Text("\(showNumber)")
                                                .font(.caption)
                                                .minimumScaleFactor(0.01)
                                                .foregroundColor(.white)
                                                .scaleEffect(0.8)
                                        }
                                        .frame(width:18,height: 18)
                                        .cornerRadius(9)
                                        .offset(x:9,y:-9)
                                }else{
                                    Color.clear
                                }
                            }
                        }
                        
                        Button {
                            isShowFavorite.toggle()
                        } label: {
                            if isShowFavorite {
                                Image(systemName: "star.circle.fill")
                            }else{
                                Image(systemName: "star.circle")
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
}

struct DictonarySearchView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = DictonarySearchViewModel(isPreview: true)
        return NavigationView {
            DictonarySearchView()
                .environmentObject(vm)
        }
        .previewInterfaceOrientation(.portrait)
    }
}
