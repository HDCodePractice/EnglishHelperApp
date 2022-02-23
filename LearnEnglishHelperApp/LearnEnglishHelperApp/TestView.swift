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
        ProgressBar(length: 10, index: 3)
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
