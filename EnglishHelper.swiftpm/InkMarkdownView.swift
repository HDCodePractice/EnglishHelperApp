//
//  File.swift
//  EnglishHelper
//
//  Created by 老房东 on 2021/12/19.
//
import Foundation
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
    @State var markdownString: String = ""
    @State private var isLoading: Bool = true
    @State var grammar : Grammar
    
    var html:String {
        let parser = MarkdownParser()
        let html = parser.html(from: markdownString)
        let htmlStart = "<div style=\"padding: 40px; font-family: -apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Oxygen,Ubuntu,Cantarell,Open Sans,Helvetica Neue,sans-serif\">"
        let htmlEnd = "</div>"

        return htmlStart + html + htmlEnd
    }
    
    var body: some View{
        VStack{
            if isLoading{
                ProgressView()
            }else {
                HTMLView(html: html)
            }
        }.onAppear{
            Task {
                let url = URL(string: grammar.markdown)!
                isLoading = true
                let (data,_) = try! await URLSession.shared.data(from: url)
                markdownString = String(data: data, encoding: .utf8) ?? "加载数据失败"
                isLoading = false
            }
        }
    }
}

struct InkMarkdownView_Previews: PreviewProvider {
    static var previews: some View {
        InkMarkdownView(grammar: grammars[0])
    }
}
