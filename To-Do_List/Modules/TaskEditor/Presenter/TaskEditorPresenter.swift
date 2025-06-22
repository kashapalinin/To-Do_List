//
//  MainPresenterInput.swift
//  To-Do_List
//
//  Created by Павел Калинин on 19.06.2025.
//
import Foundation

protocol TaskEditorPresenterInput: AnyObject {
    func saveIfNeeded(title: String, description: String)
}

final class TaskEditorPresenter: TaskEditorPresenterInput, TaskEditorInteractorOutput {
    var router: TaskEditorRouterInput?
    weak var view: TaskEditorViewInput?
    var interactor: TaskEditorInteractorInput?
    
    private var originalTask: Task?

    func configure(with task: Task) {
        self.originalTask = task
        view?.configure(with: task)
    }
    
    func saveIfNeeded(title: String, description: String) {
        let isNotEmpty = !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        guard isNotEmpty else { return }
        
        if let original = originalTask {
            guard title != original.title ||
                    description != original.description else { return }
            let edited = Task(id: original.id,
                              title: title,
                              description: description,
                              date: Date(),
                              isCompleted: original.isCompleted)
            interactor?.update(task: edited)
        } else {
            let newTask = Task(id: UUID().uuidString, title: title, description: description, date: Date(), isCompleted: false)
            interactor?.saveIfNeeded(task: newTask)
        }
    }
}
