//
//  GridePictureItem.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-05.
//

import SwiftUI
import CommomLibrary

struct GridePictureItem: View {
    @EnvironmentObject var vm : BrowseDictionaryViewModel
    var pictureFile : LocalPictureFile
    @State var refreshMe = false
    
    var body: some View {
        VStack{
            PictureView(url: vm.getURL(pictureFile: pictureFile))
            Text(pictureFile.words.joined(separator: " / "))
        }
        .shadow(radius: 10)
    }
}

struct GridePictureItem_Previews: PreviewProvider {
    static var previews: some View {
        let vm = BrowseDictionaryViewModel()
        let chapter = vm.mokeData()
        return GridePictureItem(pictureFile: chapter!.topics.first!.pictureFiles.first!)
            .environmentObject(vm)
    }
}
