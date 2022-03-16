//
//  ListTopicView.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-31.
//

import SwiftUI
import RealmSwift

struct ListTopicView: View {
    @StateObject var vm = BrowseDictionaryViewModel()
    @ObservedResults(LocalChapter.self) var chapters
    @State private var topExpanded: Bool = true
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
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
                                NavigationLink{
                                    ListPictureView(topic: topic)
                                        .environmentObject(vm)
                                }label: {
                                    Text(topic.name)
                                }
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
                Text("Resync Data From Server")
                    .onTapGesture {
                        Task{
                            vm.cleanRealm()
                            await vm.fromServerJsonToRealm()
                        }
                    }
                Text("Clean Cache (\(vm.cacheSize))")
                    .onTapGesture {
                        vm.cleanCache()
                    }
            }
        }
        .navigationBarTitle("Browse Dictionary")
        .toolbar{
            ToolbarItem(placement: .primaryAction){
                Button(){
                    dismiss()
                }label: {
                    Text("Done").fontWeight(.semibold)
                }
            }
        }
        .task {
            await vm.fromServerJsonToRealm()
        }
    }
}

struct ListTopicView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ListTopicView()
                .environmentObject(BrowseDictionaryViewModel())
        }
    }
}
