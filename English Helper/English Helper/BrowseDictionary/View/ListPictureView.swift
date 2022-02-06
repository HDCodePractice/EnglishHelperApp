//
//  ListPictureView.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-04.
//

import SwiftUI
import RealmSwift

struct ListPictureView: View {
    let columnCount: Int = 2
    let gridSpacing: CGFloat = 16.0
    @EnvironmentObject var vm : BrowseDictionaryViewModel
        
    var topic: LocalTopic

    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: .init(.flexible(), spacing: gridSpacing), count: columnCount), spacing: gridSpacing) {
                ForEach (topic.pictureFiles) { pf in
                    GridePictureItem(pictureFile: pf)
                        .environmentObject(vm)
                }
            }
        }
    }
}

struct ListPictureView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = BrowseDictionaryViewModel()
        let chapter = vm.mokeData()
        return ListPictureView(topic: chapter!.topics.first!)
            .environmentObject(vm)
        
    }
}
