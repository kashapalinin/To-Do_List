//
//  Task.swift
//  To-Do_List
//
//  Created by Павел Калинин on 18.06.2025.
//
import Foundation

struct Task: Identifiable, Hashable {
    let id: String
    let title: String
    let description: String
    let date: Date
    var isCompleted: Bool
}

extension Task {
    init?(from taskEntity: TaskEntity) {
        self.id = taskEntity.id
        self.title = taskEntity.title
        self.description = taskEntity.body
        self.date = taskEntity.date
        self.isCompleted = taskEntity.isCompleted
    }
}
