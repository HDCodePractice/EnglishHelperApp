//
//  File.swift
//  EnglishHelper
//
//  Created by 老房东 on 2021/12/18.
//

import SwiftUI
import WebKit

struct WebView : UIViewRepresentable {
    
    let url: String
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: URL(string:url)!)
        uiView.load(request)
    }
    
}

#if DEBUG
struct WebView_Previews : PreviewProvider {
    static var previews: some View {
        WebView(url: grammars[1].url)
    }
}
#endif
