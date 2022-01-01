//
//  Extensions.swift
//  EnglishHelper
//
//  Created by 老房东 on 2021-12-31.
//

import Foundation
import SwiftUI

extension Text{
    func liacTitle() -> some View{
        self.font(.title)
            .fontWeight(.heavy)
            .foregroundColor(Color("AccentColor"))
    }
}
