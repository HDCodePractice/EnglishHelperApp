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
    @StateObject var vm = DictonarySearchViewModel()
    @ObservedResults(Topic.self) var topics
    @ObservedResults(Word.self) var words
    @State private var isLoading = false
    @State var searchFilter = ""

    var body: some View {
        List{
            ForEach(topics){ topic in
                Section(topic.name){
                    if searchFilter.isEmpty{
                        ForEach(words.where({$0.assignee.assignee.name==topic.name})){ word in
                            HStack{
                                PictureView(url: URL(string: word.pictureUrl.urlEncoded()))
                                    .frame(width: 60, height: 60)
                                    .shadow(radius: 10)
                                VStack(alignment:.leading){
                                    Text(word.name)
                                }
                            }
                        }
                    }else{
                        ForEach(words.where({$0.assignee.assignee.name==topic.name && $0.name.contains(searchFilter, options: .caseInsensitive)})){ word in
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
        .navigationTitle("Words")
        .searchable(
            text: $searchFilter,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Look up for dictonary"
        )
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
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
        }
    }
}

struct DictonarySearchView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = RealmController.preview
        return NavigationView {
            DictonarySearchView()
        }
    }
}
