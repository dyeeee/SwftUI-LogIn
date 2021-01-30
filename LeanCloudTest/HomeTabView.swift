//
//  HomeTabView.swift
//  LeanCloudTest
//
//  Created by YES on 2021/1/29.
//

import SwiftUI

struct HomeTabView: View {
    var body: some View {
        TabView {
            Text("Hello, World!")
                .tabItem {
                    Image(systemName: "1.square")
                    Text("TAB1") }
            
            AlertTestView()
                .tabItem {
                    Image(systemName: "2.square")
                    Text("TAB2") }
            
            PersonalView()
                .tabItem {
                    Image(systemName: "3.square")
                    Text("TAB3") }
                .tag(3)
            
        }
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
