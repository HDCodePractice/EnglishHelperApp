//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-02-23.
//

import SwiftUI

struct GridListView: View {
    @State var vm = ViewModel()
    var body: some View {
        VStack(spacing:0){
            ForEach(vm.grid, id: \.self){
                row in
                HStack(spacing:0){
                    ForEach(row, id: \.self){
                        letter in
                        GridView(text: letter)
                    }
                }
            }
        }
    }
}

struct GridListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GridListView()
            GridListView().previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

struct ViewModel{
    let grid = [
        ["1","2","3","4","5","7","8","9"],
        ["1","2","3","4","5","7","8","9"],
        ["1","2","3","4","5","7","8","9"],
        ["1","2","3","4","5","7","8","9"],
        ["1","2","3","4","5","7","8","9"],
        ["1","2","3","4","5","7","8","9"]
//        ["a","b","c"],
//        ["a","b","c"],
//        ["a","b","c"],
//        ["a","b","c"]
    ]
}

    //.font(.system(size: 300))
