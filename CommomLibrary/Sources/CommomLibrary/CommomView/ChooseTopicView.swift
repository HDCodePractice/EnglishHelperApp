//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-04-21.
//

import SwiftUI
import RealmSwift

public struct ChooseTopicView: View {
    @ObservedResults(Chapter.self) var chapters
    @ObservedResults(Word.self) var words
    @Binding var topicNames : [String]
    
    public init(selectedTopic: Binding<[String]>){
        self._topicNames = selectedTopic
    }
    
    @Environment(\.dismiss) var dismiss
    
    public var body: some View {
        List{
            ForEach(chapters){ chapter in
                let wordCount = words.where({
                    $0.assignee.assignee.assignee.name == chapter.name
                }).count
                Section("\(chapter.name)(\(wordCount))"){
                    ForEach(chapter.topics){ topic in
                        HStack{
                            let wordCount = words.where({
                                $0.assignee.assignee.name == topic.name
                            }).count
                            Text("\(topic.name)(\(wordCount))")
                            Spacer()
                            if topicNames.contains(topic.name){
                                Image(systemName: "checkmark.circle.fill")
                            }
                        }
                        .onTapGesture {
                            if topicNames.contains(topic.name){
                                if let index = topicNames.firstIndex(of: topic.name){
                                    topicNames.remove(at: index)
                                }
                            }else{
                                topicNames.append(topic.name)
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Choose topic(\(words.count))")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading){
                Button(){
                    topicNames = []
                }label: {
                    Text("Clean").fontWeight(.semibold)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing){
                Button(){
                    dismiss()
                }label: {
                    Text("Done").fontWeight(.semibold)
                }
            }
        }
    }
}

private struct testView: View {
    @State var selectedTopic = [String]()
    var body: some View {
        ChooseTopicView(selectedTopic: $selectedTopic)
    }
}

struct ChooseTopicView_Previews: PreviewProvider {
    static var previews: some View {
        let _ = RealmController.preview
        return NavigationView{
            testView()
        }
    }
}
