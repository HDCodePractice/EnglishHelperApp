//
//  WordSearchGameView.swift
//  English Helper
//
//  Created by 老房东 on 2022-02-14.
//

import SwiftUI

struct WordSearchGameView: View {
    @EnvironmentObject var vm : WordSearchViewModel
    
    var body: some View {
        WordListGrid()
            .environmentObject(vm)
    }
}

struct WordSearchGameView_Previews: PreviewProvider {
    static var previews: some View {
        WordSearchGameView()
            .environmentObject(WordSearchViewModel())
    }
}
