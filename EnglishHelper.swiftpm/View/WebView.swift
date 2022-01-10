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
        uiView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 13_1_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.0.1 Mobile/15E148 Safari/604.1"
        let request = URLRequest(url: URL(string:url)!)
        uiView.load(request)
    }
    
}

struct WebView_Previews : PreviewProvider {
    static var previews: some View {
        WebView(url: grammars[1].url)
//        WebView(url: "https://www.google.com/search?client=safari&rls=en&q=pronounce+swift&ie=UTF-8&oe=UTF-8")
    }
}
