//
//  TestView.swift
//  LearnEnglishHelperApp
//
//  Created by 老房东 on 2022-02-22.
//

import SwiftUI


struct EnumPickerDemoView: View {
    var body: some View {
        VStack{
            let a = "Hello"
//            let answers1  = NSLocalizedString("Which picture is \(a)?\n\n#EnglishHelper #\(a)", comment: "")
            let answers1 = String(localized: "Which picture is \(a)?\n\n#EnglishHelper #\(a)")
            Text(answers1)
            let answers  = LocalizedStringKey("Which picture is \(a)?\n\n#EnglishHelper #\(a)")
            Text(answers)

        }
    }
}

struct EnumPickerDemoView_Previews: PreviewProvider {
    static var previews: some View {
        EnumPickerDemoView()
            .environment(\.locale, .init(identifier: "en"))
        EnumPickerDemoView()
            .environment(\.locale, .init(identifier: "zh"))
    }
}
