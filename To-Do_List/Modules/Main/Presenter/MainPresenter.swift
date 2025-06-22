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
}
