//
//  TestView.swift
//  LearnEnglishHelperApp
//
//  Created by 老房东 on 2022-02-22.
//

import SwiftUI
import CommomLibrary

struct TestView: View {
    var body: some View {
        WebView(url: "https://www.google.com/search?client=safari&rls=en&q=pronounce+swift&ie=UTF-8&oe=UTF-8")
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
