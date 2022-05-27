//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-04-25.
//

import SwiftUI
import RealmSwift

public struct SelectTopicsView: View {
    @ObservedResults(Chapter.self) var chapters
    @ObservedResults(Word.self) var words
    @ObservedResults(ChapterSelect.self) var chapterSelects
    @ObservedResults(TopicSelect.self) var topicSelects
    @Environment(\.dismiss) var dismiss
    @StateObject private var vm = SelectTopicsViewModel()
    
    @State private var topExpanded: Bool = true
    @State private var isSyncing : Bool = false
    
    public init(){}
    
    public var body: some View {
        List{
            Section{
                ForEach (chapters) { chapter in
                    DisclosureGroup(isExpanded:$topExpanded){
                        ForEach (chapter.topics){ topic in
                            HStack{
                                let topicSelectCount = topicSelects.where{
                                    $0.name==topic.name && $0.isSelected==false
                                }.count
                                Image(systemName: "star.fill")
                                    .foregroundColor((topicSelectCount==0) ? .yellow :
                                            .secondary)
                                let wordCount = words.where{
                                    $0.assignee.assignee.name == topic.name
                                }.count
                                Text("\(topic.name)(\(wordCount))")
                            }
                            .onTapGesture {
                                vm.toggleTopic(topic: topic)
                            }
                        }
                    }label: {
                        HStack{
                            let chapterSelectCount = chapterSelects.where{
                                $0.name==chapter.name && $0.isSelected==false
                            }.count
                            Image(systemName: "star.fill")
                                .foregroundColor((chapterSelectCount==0) ? .yellow : .secondary)
                            let wordCount = words.where{
                                $0.assignee.assignee.assignee.name == chapter.name
                            }.count
                            Text("\(chapter.name)(\(wordCount))")
                        }
                        .onTapGesture(){
                            vm.toggleChapter(chapter: chapter)
                        }
                    }
                }
            }
            
            Section{
                HStack{
                    Text("Resync Data From Server")
                    if isSyncing{
                        ProgressView()
                    }
                }
                .onTapGesture {
                    Task{
                        isSyncing = true
                        await vm.fetchData()
                        isSyncing = false
                    }
                }
                Text("Clean Cache (\(vm.cacheSize))")
                    .onTapGesture {
                        vm.cleanCache()
                    }
            }
        }
        .navigationBarTitle("Select Topics(\(words.count))")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar{
            ToolbarItem(placement: .primaryAction){
                Button(){
                    dismiss()
                }label: {
                    Text("Done").fontWeight(.semibold)
                }
            }
        }
    }
}

struct SelectTopicsView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = RealmController.preview
        return NavigationView{
            SelectTopicsView()
        }
    }
}
