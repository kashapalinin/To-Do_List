//
//  TaskEditorViewController.swift
//  To-Do_List
//
//  Created by Павел Калинин on 19.06.2025.
//

import UIKit

protocol TaskEditorViewInput: AnyObject {
    func configure(with task: Task) 
    func getEditedTask() -> (title: String, description: String)
}

final class TaskEditorViewController: UIViewController, TaskEditorViewInput {
    private let taskEditorView = TaskEditorView()
    var presenter: TaskEditorPresenterInput?
    
    override func loadView() {
        view = taskEditorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        taskEditorView.textView.delegate = self
        setupNavBar()
        applyDynamicStyle()
        enableKeyboardDismissGestures()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let (title, description) = taskEditorView.getTitleAndDescription()
        presenter?.saveIfNeeded(title: title, description: description)
    }

    private func setupNavBar() {
        navigationController?.navigationBar.tintColor = .primary
    }
    
    func configure(with task: Task) {
        taskEditorView.configure(with: task)
    }

    func getEditedTask() -> (title: String, description: String) {
        taskEditorView.getTitleAndDescription()
    }
}

extension TaskEditorViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        applyDynamicStyle()
    }
    
    private func applyDynamicStyle() {
        let fullText = taskEditorView.textView.text ?? ""
        let lines = fullText.components(separatedBy: .newlines)
        let attributed = NSMutableAttributedString(string: fullText)
        
        attributed.addAttribute(.font, value: UIFont.systemFont(ofSize: FontConstants.default.rawValue), range: NSRange(location: 0, length: attributed.length))
        attributed.addAttribute(.foregroundColor, value: UIColor.text, range: NSRange(location: 0, length: attributed.length))
        
        if let firstLine = lines.first, !firstLine.isEmpty,
           let range = fullText.range(of: firstLine) {
            let nsRange = NSRange(range, in: fullText)
            attributed.addAttribute(.font, value: UIFont.systemFont(ofSize: FontConstants.firstLine.rawValue, weight: .bold), range: nsRange)
            attributed.addAttribute(.foregroundColor, value: UIColor.text, range: nsRange)
        }
        
        let selectedRange = taskEditorView.textView.selectedRange
        taskEditorView.textView.attributedText = attributed
        taskEditorView.textView.selectedRange = selectedRange
    }
}
