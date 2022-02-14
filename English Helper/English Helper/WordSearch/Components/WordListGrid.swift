//
//  WordListGrid.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-12.
//

import SwiftUI

struct WordListGrid: View {
    @EnvironmentObject var vm : WordSearchViewModel 
    
    var body: some View {
        VStack{
            ForEach (vm.grid,id:\.self){ row in
                HStack{
                    ForEach (row){ c in
                        GridCell(cell: c)
                    }
                }
            }
        }
        .padding()
    }
}

struct WordListGrid_Previews: PreviewProvider {
    static var previews: some View {
        WordListGrid()
            .environmentObject(WordSearchViewModel())
    }
}
