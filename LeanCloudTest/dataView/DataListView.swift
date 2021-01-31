//
//  DataListView.swift
//  LeanCloudTest
//
//  Created by YES on 2021/1/31.
//

import SwiftUI

struct DataListView: View {
    @StateObject var vm = DataVM()
    
    var body: some View {
        NavigationView {
            List {
                Section{
                    VStack{
                        Button(action: {
                            vm.uploadToCloud()
                        }, label: {
                            Text("上传到云端")
                        })
                    }
                    VStack{
                        Button(action: {
                            vm.downloadFromCloud()
                        }, label: {
                            Text("从云端同步")
                        })
                    }
                }
                
                Section{
                ForEach(vm.toDoList,id:\.self){
                    todo in
                    VStack(alignment:.leading) {
                        HStack{
                            Text("ID: \(todo.id)")
                            Text("Content: \(todo.content ?? "nocontent")")
                        }
                        HStack{
                            Text("Create At: \(todo.timestamp?.timestamp! ?? Date(), formatter: itemFormatter)")
                        }
                    }
                }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Data")
            .navigationBarItems(leading: Button(action: {
                vm.deleteAll()
            }, label: {
                Text("DeleteAll")
            }),trailing: Button(action: {
                vm.createTestItem()
            }, label: {
                Text("CreateTest")
            }))
        }
    }
}



struct DataListView_Previews: PreviewProvider {
    static var previews: some View {
        DataListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
