//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-02-22.
//

import SwiftUI

public struct ProgressBar: View {
    var length : Int
    var index : Int
    private var progress: Double{
        let progressValue = Double(index+1)/Double(length)
        return progressValue > 1.0 ? 1.0 : progressValue
    }
 
    public init(length: Int,index: Int){
        self.length = length
        self.index = index
    }
    
    public var body: some View {
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
