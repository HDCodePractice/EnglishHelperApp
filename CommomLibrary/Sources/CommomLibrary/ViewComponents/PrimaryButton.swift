//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-02-22.
//

import SwiftUI

public struct PrimaryButton: View {
    var text: LocalizedStringKey
    var background: Color
    var newNumber: String
    
    public var body: some View {
        HStack{
            Text(text)
            if newNumber.count>0 {
                Color.white
                    .overlay {
                        Text("\(newNumber)")
                            .font(.caption)
                            .minimumScaleFactor(0.01)
                            .foregroundColor(background)
                            .scaleEffect(0.8)
                    }
                    .frame(width:18,height: 18)
                    .cornerRadius(9)
            }
        }
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
    init(_ text: LocalizedStringKey, background: Color = .accent, newNumber: String = ""){
        self.text = text
        self.background = background
        self.newNumber = newNumber
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            PrimaryButton("Next")
            PrimaryButton("Next",background: .red)
            PrimaryButton("Next",newNumber: "99+")
        }
    }
}
