//
//  MainInteractorOutput.swift
//  To-Do_List
//
//  Created by Павел Калинин on 19.06.2025.
//


protocol TaskEditorInteractorOutput: AnyObject {}

protocol TaskEditorInteractorInput: AnyObject {
    func saveIfNeeded(task: Task)
    func update(task: Task)
}

final class TaskEditorInteractor: TaskEditorInteractorInput {
    weak var presenter: TaskEditorInteractorOutput?
    private var taskService: TaskServiceProtocol?
    
    init(taskService: TaskServiceProtocol? = ServiceLocator.shared.taskService) {
        self.taskService = taskService
    }
    
    func saveIfNeeded(task: Task) {
        taskService?.save(task: task)
    }

    func update(task: Task) {
        taskService?.update(task: task)
    }
}
