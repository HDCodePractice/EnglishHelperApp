import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            VStack {
                WordsGameView()
            }
            .tabItem({ TabLabel(imageName: "house.fill", label: "Home") })

            VStack {
                GrammarListView()
            }
            .tabItem({ TabLabel(imageName: "book", label: "Grammar") })

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
