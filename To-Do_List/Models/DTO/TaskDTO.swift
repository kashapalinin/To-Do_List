//
//  TaskDTO.swift
//  To-Do_List
//
//  Created by Павел Калинин on 19.06.2025.
//
import Foundation

struct TaskDTO: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userID: Int
    
    enum CodingKeys: String, CodingKey {
        case id, todo, completed
        case userID = "userId"
    }
}

extension TaskDTO {
    func toTask() -> Task {
        Task(id: String(id),
             title: todo,
             description: "",
             date: Date(),
             isCompleted: completed)
    }
}
