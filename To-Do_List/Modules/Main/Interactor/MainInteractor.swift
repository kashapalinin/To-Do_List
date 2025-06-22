//
//  MainInteractor.swift
//  To-Do_List
//
//  Created by Павел Калинин on 18.06.2025.
//
import Foundation
import Combine

protocol MainInteractorOutput: AnyObject {
    func didLoadTasks(_ tasks: [Task])
    func didUpdateTask(with task: Task)
    func showError(_ error: Error)
}

protocol MainInteractorInput: AnyObject {
    func getTasks()
    func searchTasks(by query: String)
    func toggleCompletion(id: String)
    func deleteTask(id: String)
}

final class MainInteractor: MainInteractorInput {
    weak var presenter: MainInteractorOutput?
    private var taskService: TaskServiceProtocol?
    var cancellables = Set<AnyCancellable>()
    
    init(taskService: TaskServiceProtocol? = ServiceLocator.shared.taskService) {
        self.taskService = taskService
        setupBindings()
    }

    func getTasks() {
        taskService?.getTasks()
    }

    func searchTasks(by query: String) {
        taskService?.searchTasks(by: query)
    }

    func toggleCompletion(id: String) {
        taskService?.toggleCompletion(id: id)
    }

    func deleteTask(id: String) {
        taskService?.deleteTask(id: id)
    }
    
    private func setupBindings() {
        taskService?.tasksPublisher
            .receive(on: DispatchQueue.main)
            .sink { tasks in
                self.presenter?.didLoadTasks(tasks)
            }
            .store(in: &cancellables)
        
        taskService?.taskDidUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] task in
                self?.presenter?.didUpdateTask(with: task)
            }
            .store(in: &cancellables)
        
        taskService?.errorRecieved
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.presenter?.showError(error)
            }
            .store(in: &cancellables)
    }
}
