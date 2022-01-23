//
//  ProgressBar.swift
//  English Helper
//
//  Created by 老房东 on 2022-01-17.
//

import SwiftUI

struct ProgressBar: View {
    var length : Int
    var index : Int
    private var progress: Double{
        return Double(index+1)/Double(length)
    }
    
    var body: some View {
        ZStack(alignment: .leading){
            ProgressView("",value: progress)
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(length: 10,index: 5)
    }
}
