//
//  DictonarySearchMainView.swift
//  
//
//  Created by 老房东 on 2022-06-01.
//

import SwiftUI

public struct DictonarySearchMainView: View {
    @StateObject var vm = DictonarySearchViewModel()
    
    public init(){}
    
    public var body: some View {
        DictonarySearchView()
            .environmentObject(vm)
    }
}
