//
//  TaskTableViewDelegate.swift
//  To-Do_List
//
//  Created by Павел Калинин on 18.06.2025.
//
import UIKit

final class TaskTableViewDelegate: NSObject, UITableViewDelegate {
    weak var viewController: MainViewController?
    
    init(viewController: MainViewController? = nil) {
        self.viewController = viewController
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let id = viewController?.dataSource.getTask(at: indexPath.row)?.id else { return }
        viewController?.presenter?.toggleCompletion(id: id)
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) {[weak self] _ in
            let edit = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                self?.viewController?.presenter?.showTaskEditorModule(task: self?.viewController?.dataSource.getTask(at: indexPath.row))
            }

            let delete = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                guard let id = self?.viewController?.dataSource.getTask(at: indexPath.row)?.id else { return }
                self?.viewController?.dataSource.deleteTask(at: indexPath.row)
                self?.viewController?.presenter?.deleteTask(id: id)
            }

            return UIMenu(title: "", children: [edit, delete])
        }
    }
}
