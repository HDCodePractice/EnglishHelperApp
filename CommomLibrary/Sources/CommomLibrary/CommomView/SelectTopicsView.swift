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
                                Image(systemName: "star.fill")
                                    .foregroundColor(topic.isSelect ? .yellow :
                                            .secondary)
                                    .onTapGesture {
                                         vm.toggleTopic(topic: topic)
                                    }
                                Text(topic.name)
                            }
                        }
                    }label: {
                        HStack{
                            Image(systemName: "star.fill")
                                .foregroundColor(chapter.isSelect ? .yellow : .secondary)
                                .onTapGesture(){
                                    vm.toggleChapter(chapter: chapter)
                                }
                            Text(chapter.name)
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
        .navigationBarTitle("Browse Dictionary")
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
