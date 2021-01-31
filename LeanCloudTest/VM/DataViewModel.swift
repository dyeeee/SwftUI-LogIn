//
//  DataViewModel.swift
//  LeanCloudTest
//
//  Created by YES on 2021/1/31.
//

import Foundation
import CoreData
import SwiftUI
import LeanCloud

class DataVM: ObservableObject {
    @Published var toDoList: [ToDoItem] = []
    
    init() {
        getAllItems()
    }
    
    func getAllItems() {
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        let sort = NSSortDescriptor(key: "id", ascending: true)
        
        fetchRequest.sortDescriptors = [sort]
        do {
            //获取所有的Item
            toDoList = try viewContext.fetch(fetchRequest)
        } catch {
            NSLog("Error fetching tasks: \(error)")
        }
        
    }
    
    func createTestItem() {
        let viewContext = PersistenceController.shared.container.viewContext
        
        for i in 0..<10 {
            let todo = ToDoItem(context: viewContext)
            todo.id = Int16(i)
            todo.content = String("todo: \(i)|\(i)|\(i)")
            todo.isChanged = false
            
            let timestamp = Item(context: viewContext)
            timestamp.timestamp = Date()
            
            todo.timestamp = timestamp
            
        }
        
        do {
            try viewContext.save()
            getAllItems()
            print("完成保存并重新给数据列表赋值")
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    
    func deleteAll()  {
        let viewContext = PersistenceController.shared.container.viewContext
        let allItems = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoItem")
        let delAllRequest = NSBatchDeleteRequest(fetchRequest: allItems)
         do {
            try viewContext.execute(delAllRequest)
            print("删除全部数据")
            saveToPersistentStore()
            getAllItems()
         }
         catch { print(error) }
    }
    
    //保存
    func saveToPersistentStore() {
        let viewContext = PersistenceController.shared.container.viewContext
        do {
            try viewContext.save()
            //getAllItems()
            print("完成保存")
        } catch {
            NSLog("Error saving managed object context: \(error)")
        }
    }
    
    func uploadToCloud() {
        let user = LCApplication.default.currentUser?.username?.stringValue ?? "Anonymous"
        
        // 创建一个保存所有 LCObject 的数组
        var objects: [LCObject] = []
        
        //可以通过predicate获取有更改的对象，同步完成后这些对象设置为未更改
        for todo in toDoList {
            do {
                // 构建对象
                let cloudToDo = LCObject(className: "ToDoTest")

                // 为属性赋值
                try cloudToDo.set("id", value: todo.id)
                try cloudToDo.set("content", value: "\(String(describing: todo.content ?? "noContent"))")
                try cloudToDo.set("user", value: "\(String(describing: user))")
                // 将对象添加到数组
                objects.append(cloudToDo)
            } catch {
                print(error)
            }
        }
        
        // 批量构建和更新
        _ = LCObject.save(objects, completion: { (result) in
            switch result {
            case .success:
                print("保存到云端完成")
                break
            case .failure(error: let error):
                print(error)
            }
        })
    }
    
    func downloadFromCloud() {
        let user = LCApplication.default.currentUser?.username?.stringValue ?? "Anonymous"
        let viewContext = PersistenceController.shared.container.viewContext
        
        
        let query = LCQuery(className: "ToDoTest")
        query.whereKey("user", .equalTo("\(user)"))
        _ = query.find { result in
            switch result {
            case .success(objects: let todos_cloud):
                // 是包含满足条件的对象的数组
                for todo_cloud in todos_cloud {
                    let todo_local = ToDoItem(context: viewContext)
                    todo_local.id = Int16(todo_cloud.get("id")?.intValue ?? 0)
                    todo_local.content = todo_cloud.get("content")?.stringValue
                }
                self.saveToPersistentStore()
                self.getAllItems()
                break
            case .failure(error: let error):
                print(error)
            }
        }
        
    }

}
