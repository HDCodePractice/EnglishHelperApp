//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-04-25.
//

import SwiftUI
import UniformTypeIdentifiers

public struct CopyToClipboard: View {
    var putString : String
    
    public init(putString:String){
        self.putString = putString
    }
    
    public var body: some View {
        Button {
            let pasteboard = UIPasteboard.general
            pasteboard.string = putString
        } label: {
            Image(systemName: "doc.on.doc")
        }
    }
}

struct CopyToClipe_Previews: PreviewProvider {
    static var previews: some View {
        CopyToClipboard(putString: "Hello World")
    }
}
