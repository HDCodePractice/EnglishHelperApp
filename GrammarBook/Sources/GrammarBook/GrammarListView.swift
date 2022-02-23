//
//  SwiftUIView.swift
//  
//
//  Created by 老房东 on 2022-02-22.
//

import SwiftUI
import CommomLibrary

public struct GrammarListView: View {
    @StateObject var vm = GrammarListViewModel()
    
    public init(){}
    
    public var body: some View {
        VStack{
            List(vm.grammars, id: \.name){ grammar in
                NavigationLink(grammar.name){
                    WebView(url: grammar.url)
                }
            }
        }
        .navigationTitle(Text("Grammar Book",bundle: .module))
        .task {
            vm.grammars = await vm.loadData()
        }
    }
}

class GrammarListViewModel: ObservableObject{
    @Published var grammars = [Grammar]()
    private let grammarsDictURl = "https://raw.githubusercontent.com/HDCodePractice/EnglishHelper/main/res/grammar_dict.json"
    
    func loadData() async -> [Grammar]{
        if let g: [Grammar] = await loadDataByServer(url: grammarsDictURl) {
            return g
        }
        return []
    }
}


struct Grammar: Codable{
    var name: String = ""
    var url: String = ""
    var markdown : String?
    var description : String?
}

extension Grammar: Identifiable{
    var id: String {
        return self.name
    }
}

struct GrammarListView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            NavigationView{
                GrammarListView()
            }.environment(\.locale, .init(identifier: "en"))
            
            NavigationView{
                GrammarListView()
            }.environment(\.locale, .init(identifier: "zh"))
        }

    }
}
