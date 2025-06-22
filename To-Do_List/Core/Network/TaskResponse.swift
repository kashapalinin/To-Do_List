//
//  Welcome.swift
//  To-Do_List
//
//  Created by Павел Калинин on 19.06.2025.
//

struct TaskResponse: Codable {
    let todos: [TaskDTO]
    let total, skip, limit: Int
}
