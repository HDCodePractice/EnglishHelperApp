//
//  PrimaryButton.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-17.
//

import SwiftUI

struct PrimaryButton: View {
    var text: LocalizedStringKey
    var background: Color = Color("AccentColor")
    
    var body: some View {
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

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(text: "Next")
    }
}
