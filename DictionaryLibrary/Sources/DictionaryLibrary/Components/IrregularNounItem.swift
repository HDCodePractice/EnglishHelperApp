//
//  IrregularVerbItem.swift
//
//
//  Created by 老房东 on 2022-05-31.
//

import SwiftUI
import CommomLibrary
import RealmSwift

struct IrregularNounItem: View {
    var search : String
    var limit : Int = 2
    @ObservedResults(IrregularNoun.self) var irregularNouns
    
    var body: some View {
        let items = irregularNouns.where{ item in
            item.singular.contains(search) || item.plural.contains(search)
        }.prefix(limit)
        if !items.isEmpty{
            Section("Irregulary Noun"){
                ForEach(items){ item in
                    HStack{
                        Text("\(item.singular) \(item.plural)")
                    }
                }
            }
        }
    }
}

struct IrregularNounItem_Previews: PreviewProvider {
    static var previews: some View {
        let _ = RealmController.preview
        return List{ IrregularNounItem(search: "w") }
    }
}
