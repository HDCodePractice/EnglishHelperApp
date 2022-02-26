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
                    
                }
            }
        }
    }
}

struct GridListView_Previews: PreviewProvider {
    static var previews: some View {
        GridListView()
        Group {
            GridListView()
            GridListView().previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

struct ViewModel{
    let grid = [
        ["q","w","e","r","t","y","u","i","o","p"],
        ["a","s","d","f","g","h","j","k","l"],
        ["z","x","c","v","b","n","m",",","."]

    ]
}
print (grid)
