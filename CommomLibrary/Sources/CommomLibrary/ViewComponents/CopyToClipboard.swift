//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-04-25.
//

import SwiftUI
import UniformTypeIdentifiers

struct CopyToClipboard: View {
    var putString : String
    var body: some View {
        Button {
            UIPasteboard.general.setValue(
                putString,
                forPasteboardType: UTType.plainText.identifier
            )
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
