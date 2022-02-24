//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-02-23.
//

import SwiftUI

struct GridView: View {
    @State var selected : Bool = false
    
    var text: String
    
    var body: some View {
        GeometryReader{g in
            ZStack {
                Rectangle().fill(.gray).border(.white)
                Text(text).font(.system(size: g.size.height > g.size.width ? g.size.width : g.size.height))
                    .foregroundColor(selected ? .red : .primary)
                    .onTapGesture {
                    selected.toggle()
                }
            }
        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView(text: "E")
    }
}
