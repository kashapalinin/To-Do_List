//
//  TaskEntity+CoreDataClass.swift
//  To-Do_List
//
//  Created by Павел Калинин on 19.06.2025.
//
//

import Foundation
import CoreData

@objc(TaskEntity)
public class TaskEntity: NSManagedObject {
    func update(from task: Task) {
        self.id = task.id
        self.title = task.title
        self.body = task.description
        self.date = task.date
        self.isCompleted = task.isCompleted
    }
}
