//
//  ToDoItem+CoreDataProperties.swift
//  LeanCloudTest
//
//  Created by YES on 2021/1/31.
//
//

import Foundation
import CoreData


extension ToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
        return NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    }

    @NSManaged public var content: String?
    @NSManaged public var id: Int16
    @NSManaged public var isChanged: Bool
    @NSManaged public var timestamp: Item?

}

extension ToDoItem : Identifiable {

}
