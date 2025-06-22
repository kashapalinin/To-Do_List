//
//  SearchView.swift
//  To-Do_List
//
//  Created by Павел Калинин on 18.06.2025.
//
import UIKit

class SearchView: UIView {
    
    private enum Constants {
        static let searchPlaceholder = "Искать"
    }
    
    weak var searchIconDelegate: SearchIconDelegate?
    
    private lazy var searchIcon: UIImageView = {
        let searchIcon = UIImageView(image: UIImage.searchIcon.withRenderingMode(.alwaysTemplate))
        searchIcon.tintColor = .gray
        searchIcon.contentMode = .scaleAspectFit
        searchIcon.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
        return searchIcon
    }()
    
    private lazy var iconContainer: UIView = {
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        iconContainer.addSubview(searchIcon)
        iconContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(searchIconTapped)))
        return iconContainer
    }()

    private(set) lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: FontConstants.default.rawValue)
        textField.textColor = .text
        textField.backgroundColor = .secondary
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.attributedPlaceholder = NSAttributedString(
            string: Constants.searchPlaceholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.text.withAlphaComponent(0.5)]
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = iconContainer
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textField.rightViewMode = .always

        return textField
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        searchTextField.delegate = self
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupView() {
        addSubview(searchTextField)

        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: self.topAnchor),
            searchTextField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }

    @objc private func searchIconTapped() {
        searchIconDelegate?.findTrip(name: searchTextField.text ?? "")
    }

    func getText() -> String {
        searchTextField.text ?? ""
    }
}

extension SearchView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchIconTapped()
        textField.resignFirstResponder()
        return true
    }
}

protocol SearchIconDelegate: AnyObject {
    func findTrip(name: String)
}
