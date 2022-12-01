//
//  PhoneBookApp.swift
//  PhoneBook
//
//  Created by Ian Nalyanya on 01/12/2022.
//

import SwiftUI

@main
struct PhoneBookApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
