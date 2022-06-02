//
//  IrregularVerbItem.swift
//  
//
//  Created by 老房东 on 2022-05-31.
//

import SwiftUI
import CommomLibrary
import RealmSwift

struct IrregularVerbItem: View {
    var search : String
    var limit : Int = 3
    @ObservedResults(IrregularVerb.self) var irregularVerbs
    
    var body: some View {
        let items = irregularVerbs.where{ item in
            item.baseForm.contains(search) || item.simplePast.contains(search) || item.pastParticiple.contains(search)
        }.prefix(3)
        if !items.isEmpty{
            Section("Irregulary Verbs"){
                ForEach(items){ item in
                    HStack{
                        Text("\(item.baseForm) \(item.simplePast) \(item.pastParticiple)")
                    }
                }
            }
        }
    }
}

struct IrregularVerbItem_Previews: PreviewProvider {
    static var previews: some View {
        let _ = RealmController.preview
        return List{ IrregularVerbItem(search: "w") }
    }
}
