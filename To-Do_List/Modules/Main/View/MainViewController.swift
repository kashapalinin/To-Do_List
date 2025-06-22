//
//  MainViewController.swift
//  To-Do_List
//
//  Created by Павел Калинин on 18.06.2025.
//

import UIKit
import Combine

protocol MainViewInput: AnyObject {
    func showTasks(_ tasks: [Task])
    func showError(_ error: Error)
    func setLoading(_ isLoading: Bool)
    func reloadTask(with task: Task)
}

final class MainViewController: UIViewController, MainViewInput {
    private let mainView: MainView = MainView()
    var presenter: MainPresenterInput?
    var cancellables = Set<AnyCancellable>()
    
    private(set) lazy var countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text
        label.text = "100 задач"
        label.font = .systemFont(ofSize: FontConstants.default.rawValue)
        return label
    }()
    
    private(set) lazy var dataSource: TaskTableViewDataSource = {
        TaskTableViewDataSource(viewController: self)
    }()

    private(set) lazy var delegate: TaskTableViewDelegate = {
        TaskTableViewDelegate(viewController: self)
    }()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupToolbar()
        setupNavBar()
        addToolbarBackgroundExtension()
        dataSource.setupDataSource(tableView: mainView.tableView)
        mainView.tableView.delegate = delegate
        presenter?.loadTasks()
        bindSearch()
        enableKeyboardDismissGestures()
    }

    private func setupToolbar() {
        let labelItem = UIBarButtonItem(customView: countLabel)
        
        let composeItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(addButtonTapped))
        composeItem.tintColor = .primary
        
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbarItems = [flexible, labelItem, flexible, composeItem]
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.backgroundColor = .secondary
    }

    private func addToolbarBackgroundExtension() {
        guard let window = view.window ?? UIApplication.shared.windows.first else { return }

        let bottomInset = window.safeAreaInsets.bottom
        guard bottomInset > 0 else { return }

        let extensionView = UIView()
        extensionView.backgroundColor = .secondary
        extensionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(extensionView)
        
        NSLayoutConstraint.activate([
            extensionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            extensionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            extensionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            extensionView.heightAnchor.constraint(equalToConstant: bottomInset)
        ])
    }

    private func setupNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: mainView.title)
    }

    @objc
    private func addButtonTapped() {
        presenter?.showAddTaskModule()
    }

    func showTasks(_ tasks: [Task]) {
        dataSource.updateSnapshot(with: tasks, animation: true)
        countLabel.text = formTasksString(tasks.count)
    }

    func showError(_ error: Error) {
        let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription

        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func setLoading(_ isLoading: Bool) {
        mainView.setLoading(isLoading)
    }

    func reloadTask(with task: Task) {
        guard let index = dataSource.getItems().firstIndex(where: { $0.id == task.id }) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        dataSource.update(with: task, at: index)
    }
    
    private func bindSearch() {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: mainView.searchView.searchTextField)
            .compactMap { ($0.object as? UITextField)?.text }
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.presenter?.search(query: text)
            }
            .store(in: &cancellables)
    }

    private func formTasksString(_ count: Int) -> String {
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
