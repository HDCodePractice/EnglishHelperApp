//
//  SelectTopicsView.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-28.
//

import SwiftUI

struct SelectTopicsView: View {
    @EnvironmentObject var vm : PictureGameViewModel
    @State private var topExpanded: Bool = true
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView{
            List{
                ForEach (vm.chapters) { chapter in
                    DisclosureGroup(isExpanded:$topExpanded){
                        ForEach (chapter.topics){ topic in
                            HStack{
                                Text(topic.name)
                                Image(systemName: "star.fill")
                                    .foregroundColor(topic.isSelect ? .yellow :
                                                            .secondary)
                                    .onTapGesture {
                                        vm.toggleTopic(name: topic.name, chaptername: chapter.name)
                                    }
                            }
                        }
                    }label: {
                        HStack{
                            Text(chapter.name)
                            Image(systemName: "star.fill")
                                .foregroundColor(chapter.isSelect ? .yellow : .secondary)
                                .onTapGesture(){
                                    vm.toggleChapter(name: chapter.name)
                                }
                        }
                    }
                }
            }
            .navigationBarTitle("Select Topics")
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
}

struct SelectTopicsView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = PictureGameViewModel()
        vm.mokeData()
        return SelectTopicsView()
            .environmentObject(vm)
    }
}
