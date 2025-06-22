//
//  TaskTableViewDataSource.swift
//  To-Do_List
//
//  Created by Павел Калинин on 18.06.2025.
//
import UIKit

enum Sections {
    case main
}

final class TaskTableViewDataSource: NSObject {
    weak var viewController: MainViewController?
    private var dataSource: UITableViewDiffableDataSource<Sections, Task>?
    
    init(viewController: MainViewController? = nil) {
        self.viewController = viewController
    }
        
    func setupDataSource(with items: [Task] = [], tableView: UITableView) {
        dataSource = UITableViewDiffableDataSource(tableView: tableView,
                                                   cellProvider: { tableView, indexPath, task in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskTableViewCell.reuseIdentifier,
                                                           for: indexPath) as?  TaskTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: task)
            return cell
        })
        
        dataSource?.defaultRowAnimation = .fade
        updateSnapshot(with: items, animation: true)
    }
    
    func updateSnapshot(with items: [Task], animation: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Sections, Task>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        
        dataSource?.apply(snapshot, animatingDifferences: animation)
    }

    func getItems() -> [Task] {
        dataSource?.snapshot().itemIdentifiers ?? []
    }

    func getCount() -> Int {
        dataSource?.snapshot().numberOfItems ?? 0
    }

    func getTask(at index: Int) -> Task? {
        dataSource?.snapshot().itemIdentifiers[index]
    }

    func update(with task: Task, at index: Int, animated: Bool = true) {
        guard var snapshot = dataSource?.snapshot() else { return }
        let oldTask = snapshot.itemIdentifiers[index]
        snapshot.insertItems([task], beforeItem: oldTask)
        snapshot.deleteItems([oldTask])
        dataSource?.apply(snapshot, animatingDifferences: animated)
    }

    func deleteTask(at index: Int, animated: Bool = true) {
        guard var snapshot = dataSource?.snapshot() else { return }
        let taskToDelete = snapshot.itemIdentifiers[index]
        snapshot.deleteItems([taskToDelete])
        dataSource?.apply(snapshot, animatingDifferences: animated) {[weak self] in
            self?.viewController?.showTasks(snapshot.itemIdentifiers)
        }
    }
}
