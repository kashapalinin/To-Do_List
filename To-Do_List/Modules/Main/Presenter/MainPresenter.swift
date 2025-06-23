//
//  MainPresenter.swift
//  To-Do_List
//
//  Created by Павел Калинин on 18.06.2025.
//

protocol MainPresenterInput: AnyObject {
    func showTaskEditorModule(task: Task?)
    func showAddTaskModule()
    func loadTasks()
    func search(query: String)
    func toggleCompletion(id: String)
    func deleteTask(id: String)
    func showError(_ error: Error)
    func formTasksString(_ count: Int) -> String
}

final class MainPresenter: MainPresenterInput, MainInteractorOutput {
    var router: MainRouterInput?
    weak var view: MainViewInput?
    var interactor: MainInteractorInput?
    
    func showTaskEditorModule(task: Task?) {
        router?.showTaskEditorModule(with: task)
    }

    func showAddTaskModule() {
        router?.showTaskEditorModule()
    }

    func didLoadTasks(_ tasks: [Task]) {
        view?.showTasks(tasks)
        view?.setLoading(false)
    }

    func loadTasks() {
        view?.setLoading(true)
        interactor?.getTasks()
    }

    func search(query: String) {
        interactor?.searchTasks(by: query)
    }

    func toggleCompletion(id: String) {
        interactor?.toggleCompletion(id: id)
    }

    func didUpdateTask(with task: Task) {
        view?.reloadTask(with: task)
    }

    func deleteTask(id: String) {
        interactor?.deleteTask(id: id)
    }
    
    func showError(_ error: Error) {
        view?.showError(error)
        view?.setLoading(false)
    }
    
    func formTasksString(_ count: Int) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100
        
        var wordForm: String
        
        if remainder10 == 1 && remainder100 != 11 {
            wordForm = "задача"
        } else if remainder10 >= 2 && remainder10 <= 4 && !(remainder100 >= 12 && remainder100 <= 14) {
            wordForm = "задачи"
        } else {
            wordForm = "задач"
        }
        
        return "\(count) \(wordForm)"
    }
}
