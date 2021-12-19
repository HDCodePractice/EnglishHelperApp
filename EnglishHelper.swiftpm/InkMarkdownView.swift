//
//  File.swift
//  EnglishHelper
//
//  Created by 老房东 on 2021/12/19.
//

import SwiftUI
import WebKit
import Ink

struct HTMLView: UIViewRepresentable {
    var html: String
    
    init(html: String) {
        self.html = html
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(html, baseURL: nil)
    }
}


struct InkMarkdownView: View{
    var markdownString : String
    
    var html:String{
        let parser = MarkdownParser()
        let html = parser.html(from: markdownString)
        let htmlStart = "<div style=\"padding: 40px; font-family: -apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Oxygen,Ubuntu,Cantarell,Open Sans,Helvetica Neue,sans-serif\">"
        let htmlEnd = "</div>"

        return htmlStart + html + htmlEnd
    }
    
    var body: some View{
        HTMLView(html: html)
    }
}

struct InkMarkdownView_Previews: PreviewProvider {
    static var previews: some View {
        InkMarkdownView(markdownString: """
# 你好

|abc|bbc|cbc|
|-|-|-|
|1|2|3|

## 第二句

""")
    }
}
