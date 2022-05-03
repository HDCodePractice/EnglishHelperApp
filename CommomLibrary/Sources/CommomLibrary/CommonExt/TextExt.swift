//
//  TextExt.swift
//  
//
//  Created by 老房东 on 2022-04-26.
//

import SwiftUI

public extension Text{
    func liacTitle() -> some View{
        self.font(.title)
            .fontWeight(.heavy)
            .foregroundColor(.accent)
    }
}
