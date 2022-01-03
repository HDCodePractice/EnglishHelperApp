//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-01-01.
//

import SwiftUI
import UIKit

struct TranslateTextView: UIViewControllerRepresentable {
    @Binding var text : String
    @Binding var showing : Bool


    func makeUIViewController(context: Context) -> UINavigationController {
        let navController =  UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)
        let viewController = UIViewController()
        navController.addChild(viewController)
        navController.delegate = context.coordinator
        return navController
    }

    func updateUIViewController(_ pageViewController: UINavigationController, context: Context) {
        print("text:\(text) showing:\(showing)")
        if showing {
            translate(pageViewController,text: text)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    class Coordinator: NSObject,UINavigationControllerDelegate {
        var parent: TranslateTextView

        init(_ translateTextView: TranslateTextView) {
            self.parent = translateTextView
        }
    }

    func translate(_ navController:UINavigationController , text: String) {
        guard !text.isEmpty else {
            return
        }
        print("translate1 \(text)")
        if #available(iOS 15.0, *) {
            let text = text.unicodeScalars.filter { !$0.properties.isEmojiPresentation}.reduce("") { $0 + String($1) }
            
            let textView = UITextView()
            textView.text = text
            textView.isEditable = false
            print("translate2 \(text) ")
            if let topController = navController.topViewController{
                print("translate3 \(text)")
                topController.view.addSubview(textView)
                textView.selectAll(nil)
                textView.perform(NSSelectorFromString(["_", "trans", "late:"].joined(separator: "")), with: nil)
                
                DispatchQueue.main.async {
                    textView.removeFromSuperview()
                    showing = false
                    print("removeFromSuperview")
                }
            }
        }
    }

}


struct DemoTranslateTextView: View {
    @State var text = "Hello World"
    @State var translate = false
    
    var body: some View {
        let translateTextView = TranslateTextView(text: $text, showing: $translate)
        return VStack{
            translateTextView
                .frame(width: 0, height: 0)
            Button("Translate"){
                translate = true
            }.buttonStyle(.borderedProminent)
        }
    }
}

struct TranslateTextView_Previews : PreviewProvider {
    static var previews: some View {
        DemoTranslateTextView()
    }
}
