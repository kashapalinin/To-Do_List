//
//  TaskEditorAssembly.swift
//  To-Do_List
//
//  Created by Павел Калинин on 19.06.2025.
//
import UIKit

final class TaskEditorAssembly {
    static func build(task: Task?) -> UIViewController {
        let vc = TaskEditorViewController()
        let presenter = TaskEditorPresenter()
        let router = TaskEditorRouter()
        let interactor = TaskEditorInteractor()

        vc.presenter = presenter
        presenter.view = vc
        presenter.interactor = interactor
        presenter.router = router
        router.vc = vc
        interactor.presenter = presenter

        if let task = task {
            presenter.configure(with: task)
        }
        
        return vc
    }
}
