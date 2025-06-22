//
//  MainRouter.swift
//  To-Do_List
//
//  Created by Павел Калинин on 18.06.2025.
//
import UIKit

protocol MainRouterInput: AnyObject {
    func showTaskEditorModule(with task: Task?)
}

extension MainRouterInput {
    func showTaskEditorModule() {
        showTaskEditorModule(with: nil)
    }
}

final class MainRouter: MainRouterInput {
    weak var vc: UIViewController?
    
    func showTaskEditorModule(with task: Task?) {
        let taskEditorVC = TaskEditorAssembly.build(task: task)
        taskEditorVC.hidesBottomBarWhenPushed = true
        vc?.navigationController?.pushViewController(taskEditorVC, animated: true)
    }
}
