//
//  LeanCloudTestApp.swift
//  LeanCloudTest
//
//  Created by YES on 2021/1/29.
//

import SwiftUI

@main
struct LeanCloudTestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
