//
//  TaskTableViewCell.swift
//  To-Do_List
//
//  Created by Павел Калинин on 18.06.2025.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    private enum Constants {
        static let doneImageSize: CGFloat = 25
    }
    
    private(set) lazy var doneImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .circle
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text
        label.font = .systemFont(ofSize: FontConstants.title.rawValue)
        label.numberOfLines = 1
        return label
    }()

    private(set) lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text
        label.font = .systemFont(ofSize: FontConstants.default.rawValue)
        label.numberOfLines = 2
        return label
    }()

    private(set) lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .text.withAlphaComponent(0.5)
        label.font = .systemFont(ofSize: FontConstants.default.rawValue)
        return label
    }()
    
    private(set) lazy var textStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, dateLabel])
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = Padding.small.rawValue
        return stack
    }()

    private(set) lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [doneImage, textStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .top
        stack.spacing = Padding.default.rawValue
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
        contentView.backgroundColor = .background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLayout() {
        contentView.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            doneImage.widthAnchor.constraint(equalToConstant: Constants.doneImageSize),
            doneImage.heightAnchor.constraint(equalToConstant: Constants.doneImageSize),
            
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Padding.medium.rawValue),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Padding.medium.rawValue),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Padding.small.rawValue),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Padding.small.rawValue)
        ])
    }

    func configure(with task: Task) {
        var attributes: [NSAttributedString.Key: Any] = [:]
                
        if task.isCompleted {
            attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
            titleLabel.alpha = 0.5
            descriptionLabel.alpha = 0.5
        }  else {
            titleLabel.alpha = 1.0
            descriptionLabel.alpha = 1.0
        }
        
        let attributedString = NSAttributedString(string: task.title, attributes: attributes)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        titleLabel.attributedText = attributedString
        descriptionLabel.text = task.description
        dateLabel.text = formatter.string(from: task.date)
        doneImage.image = task.isCompleted ? .doneCircle : .circle
    }
}

extension TaskTableViewCell {
    static let reuseIdentifier = "TaskTableViewCell"
}
