import SwiftUI

@main
struct EnglishHelperApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear(){
                    UserDefaults.standard.setValue(false,forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
        }
    }
}
