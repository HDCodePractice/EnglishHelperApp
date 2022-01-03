import SwiftUI

struct ContentView: View {
    
    var body: some View {
        return TabView {
            VStack {
                WordsGameView()
            }
            .tabItem({ TabLabel(imageName: "memories", label: "Memories") })

            VStack {
                GrammarListView()
            }
            .tabItem({ TabLabel(imageName: "book", label: "Grammar") })
            
            //这个tableItem只是为测试新的功能才会使用，请忽略
//            VStack{
//                VStack {
//                    Button("Translate"){
//                    }.buttonStyle(.borderedProminent)
//
//                }
//            }
//            .tabItem({ TabLabel(imageName: "testtube.2", label: "Test") })
            
        }
    }
    
    struct TabLabel: View {
        let imageName: String
        let label: String
        
        var body: some View {
            HStack {
                Image(systemName: imageName)
                Text(label)
            }
        }
    }
}
