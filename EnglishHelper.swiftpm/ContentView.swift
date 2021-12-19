import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView{
            List(grammars, id: \.name){ grammar in
                NavigationLink(grammar.name){
                    WebView(url: grammar.url)
                }
            }
            .navigationTitle("Grammar Book")
        }
    }
}
