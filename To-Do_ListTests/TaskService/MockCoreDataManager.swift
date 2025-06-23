//
//  MockCoreDataManager.swift
//  To-Do_List
//
//  Created by Павел Калинин on 23.06.2025.
//


@testable import To_Do_List

final class MockCoreDataManager: Storage {
    var savedTasks: [Task] = []
    var updatedTasks: [Task] = []
    var deletedTaskIds: [String] = []

    func saveAll(_ tasks: [Task]) {
        savedTasks.append(contentsOf: tasks)
    }

    func add(task: Task) {
        savedTasks.append(task)
    }

    func updateTask(_ task: Task) {
        updatedTasks.append(task)
    }

    func deleteTask(by id: String) {
        deletedTaskIds.append(id)
    }

    func fetchAllTasks() -> [Task] {
        return savedTasks
    }
}
