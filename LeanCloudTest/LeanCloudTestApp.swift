//
//  LeanCloudTestApp.swift
//  LeanCloudTest
//
//  Created by YES on 2021/1/29.
//

import SwiftUI
import LeanCloud

@main
struct LeanCloudTestApp: App {
    let persistenceController = PersistenceController.shared

    init() {
        UserViewModel.LeanCloudSet()
        //LeanCloudTest()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}




