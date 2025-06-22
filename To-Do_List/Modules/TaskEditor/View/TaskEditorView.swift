//
//  TaskEditorView.swift
//  To-Do_List
//
//  Created by Павел Калинин on 19.06.2025.
//

import UIKit

final class TaskEditorView: UIView {

    private(set) lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.isScrollEnabled = true
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.textColor = .label
        return textView
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
        addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Padding.default.rawValue),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Padding.default.rawValue),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Padding.default.rawValue),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func configure(with task: Task) {
        let combinedText = [task.title, task.description].compactMap { $0 }.joined(separator: "\n")
        textView.attributedText = makeStyledText(combinedText)
    }

    func getTitleAndDescription() -> (title: String, description: String) {
        let lines = textView.text.components(separatedBy: .newlines)
        let title = lines.first?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let description = lines.dropFirst().joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
        return (title, description)
    }

    private func makeStyledText(_ text: String) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 4

        let attributed = NSMutableAttributedString(string: text)

        attributed.addAttributes([
            .font: UIFont.systemFont(ofSize: FontConstants.default.rawValue),
            .foregroundColor: UIColor.text,
            .paragraphStyle: paragraph
        ], range: NSRange(location: 0, length: attributed.length))

        let lines = text.components(separatedBy: .newlines)
        if let firstLine = lines.first, !firstLine.isEmpty,
           let titleRange = text.range(of: firstLine) {
            let nsRange = NSRange(titleRange, in: text)
            attributed.addAttributes([
                .font: UIFont.systemFont(ofSize: FontConstants.firstLine.rawValue, weight: .bold),
                .foregroundColor: UIColor.text
            ], range: nsRange)
        }

        return attributed
    }
}
