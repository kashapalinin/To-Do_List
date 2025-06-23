//
//  TaskService.swift
//  To-Do_List
//
//  Created by Павел Калинин on 19.06.2025.
//
import Foundation
import Combine

protocol TaskServiceProtocol {
    var tasksPublisher: AnyPublisher<[Task], Never> { get }
    var taskDidUpdate: PassthroughSubject<Task, Never> { get }
    var errorRecieved: PassthroughSubject<Error, Never> { get }
    func getTasks()
    func searchTasks(by query: String)
    func toggleCompletion(id: String)
    func deleteTask(id: String)
    func save(task: Task)
    func update(task: Task)
}

final class TaskService: TaskServiceProtocol {
    private let network: TasksNetworkServiceProtocol
    private let storage: Storage
    private let userDefaults: UserDefaults
    
    private var allTasks: [Task] = []
    
    private var cancellables = Set<AnyCancellable>()
    private let tasksSubject = CurrentValueSubject<[Task], Never>([])
    let taskDidUpdate = PassthroughSubject<Task, Never>()
    let errorRecieved = PassthroughSubject<Error, Never>()
    var tasksPublisher: AnyPublisher<[Task], Never> {
        tasksSubject.eraseToAnyPublisher()
    }

    private let hasLoadedKey = "hasLoadedTasks"

    init(network: TasksNetworkServiceProtocol,
         storage: Storage,
         userDefaults: UserDefaults = .standard) {
        self.network = network
        self.userDefaults = userDefaults
        self.storage = storage
    }

    func getTasks()  {
        if userDefaults.bool(forKey: hasLoadedKey) {
            let tasks = storage.fetchAllTasks()
            self.allTasks = tasks
            self.tasksSubject.send(tasks)
        } else {
            network.getTasks { [weak self] result in
                switch result {
                case .success(let dtos):
                    let tasks = dtos.map { $0.toTask() }
                    self?.storage.saveAll(tasks)
                    self?.userDefaults.set(true, forKey: self?.hasLoadedKey ?? "")
                    self?.allTasks = tasks
                    self?.tasksSubject.send(tasks)
                case .failure(let error):
                    self?.errorRecieved.send(error)
                    self?.tasksSubject.send([])
                }
            }
        }
    }

    func searchTasks(by query: String) {
        if query.isEmpty {
            tasksSubject.send(allTasks)
        } else {
            let filtered = allTasks.filter { $0.title.lowercased().contains(query.lowercased()) }
            tasksSubject.send(filtered)
        }
    }

    func toggleCompletion(id: String) {
        guard let index = allTasks.firstIndex(where: { $0.id == id }) else { return }
        var task = allTasks[index]
        task.isCompleted.toggle()
        
        storage.updateTask(task)

        allTasks[index] = task
        taskDidUpdate.send(task)
    }

    func deleteTask(id: String) {
        allTasks.removeAll { $0.id == id }
        storage.deleteTask(by: id)
    }

    func save(task: Task) {
        allTasks.insert(task, at: 0)
        storage.add(task: task)
        tasksSubject.send(allTasks)
    }

    func update(task: Task) {
        guard let index = allTasks.firstIndex(where: { $0.id == task.id }) else { return }
        allTasks[index] = task
        storage.updateTask(task)
        tasksSubject.send(allTasks)
    }
}
