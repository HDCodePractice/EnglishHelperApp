//
//  Learn_English_DictionaryApp.swift
//  Learn English Dictionary
//
//  Created by 老房东 on 2022-03-26.
//

import SwiftUI
import CommomLibrary

@main
struct Learn_English_DictionaryApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
        }
    }
}
