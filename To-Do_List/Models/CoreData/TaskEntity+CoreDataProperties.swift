//
//  TaskEntity+CoreDataProperties.swift
//  To-Do_List
//
//  Created by Павел Калинин on 19.06.2025.
//
//

import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var body: String
    @NSManaged public var date: Date
    @NSManaged public var isCompleted: Bool

}

extension TaskEntity : Identifiable {

}
