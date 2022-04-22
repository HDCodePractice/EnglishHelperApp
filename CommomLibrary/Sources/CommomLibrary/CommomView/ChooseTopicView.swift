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
    @Binding var topicName : String
    
    public init(selectedTopic: Binding<String>){
        self._topicName = selectedTopic
    }
    
    @Environment(\.dismiss) var dismiss
    
    public var body: some View {
        List{
            ForEach(chapters){ chapter in
                Section("\(chapter.name)"){
                    ForEach(chapter.topics){ topic in
                        HStack{
                            Text("\(topic.name)")
                            Spacer()
                            if topicName == topic.name{
                                Image(systemName: "checkmark")
                            }
                        }
                        .onTapGesture {
                            if topicName == topic.name {
                                topicName = ""
                            }else{
                                topicName = topic.name
                            }
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Choose topic")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button(){
                dismiss()
            }label: {
                Text("Done").fontWeight(.semibold)
            }
        }
    }
}

private struct testView: View {
    @State var selectedTopic = ""
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
