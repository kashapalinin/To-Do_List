//
//  MockTasksNetworkService.swift
//  To-Do_List
//
//  Created by Павел Калинин on 23.06.2025.
//


@testable import To_Do_List

final class MockTasksNetworkService: TasksNetworkServiceProtocol {
    var result: Result<[TaskDTO], Error> = .success([])

    func getTasks(completion: @escaping (Result<[TaskDTO], Error>) -> Void) {
        completion(result)
    }
}
