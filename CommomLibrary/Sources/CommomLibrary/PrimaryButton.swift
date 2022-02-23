//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-02-22.
//

import SwiftUI

public struct PrimaryButton: View {
    var text: String
    var background: Color
    
    public var body: some View {
        Text(text)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .padding()
            .padding(.horizontal)
            .background(background)
            .cornerRadius(30)
            .shadow(radius: 10)
    }
}

public extension PrimaryButton{
    init(_ text: String, background: Color = Color.accent){
        self.text = text
        self.background = background
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton("Next")
    }
}
