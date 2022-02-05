//
//  TopicItemView.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-01.
//

import SwiftUI

struct TopicRow: View {
    var topic : String
    var checked : Bool
    
    var body: some View {
        HStack{
            Image(systemName: checked ? "checkmark.circle" : "circle")
            Text(topic)
        }
    }
}

struct TopicRow_Previews: PreviewProvider {
    static var previews: some View {
        TopicRow(topic: "Hello World", checked: true)
    }
}
