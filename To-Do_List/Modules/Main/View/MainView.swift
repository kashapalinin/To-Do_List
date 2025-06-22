//
//  MainView.swift
//  To-Do_List
//
//  Created by Павел Калинин on 18.06.2025.
//

import UIKit

final class MainView: UIView {
    private enum Constants {
        static let searchViewHeight: CGFloat = 35
        static let indicatorSize: CGFloat = 50
        static let estimatedRowHeight: CGFloat = 55
        static let title = "Задачи"
    }
    
    private(set) lazy var title: UILabel = {
        let label = UILabel()
        label.text = Constants.title
        label.textColor = .text
        label.font = .systemFont(ofSize: FontConstants.header.rawValue, weight: .bold)
        return label
    }()

    private(set) lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    private(set) lazy var searchView: SearchView = {
        let view = SearchView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.reuseIdentifier)
        tableView.backgroundColor = .background
        tableView.separatorColor = .text.withAlphaComponent(0.5)
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = .zero
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .background
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        addSubview(searchView)
        addSubview(tableView)
        addSubview(indicator)

        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Padding.default.rawValue),
            searchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Padding.default.rawValue),
            searchView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Padding.default.rawValue),
            searchView.heightAnchor.constraint(equalToConstant: Constants.searchViewHeight),
            
            tableView.topAnchor.constraint(equalTo: searchView.bottomAnchor, constant: Padding.default.rawValue),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Padding.default.rawValue),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Padding.default.rawValue),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
            indicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            indicator.widthAnchor.constraint(equalToConstant: Constants.indicatorSize),
            indicator.heightAnchor.constraint(equalToConstant: Constants.indicatorSize)
        ])
    }

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            indicator.startAnimating()
            tableView.isHidden = true
        } else {
            indicator.stopAnimating()
            tableView.isHidden = false
        }
    }
}
