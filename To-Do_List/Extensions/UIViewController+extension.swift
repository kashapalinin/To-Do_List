//
//  UIViewController+extension.swift
//  To-Do_List
//
//  Created by Павел Калинин on 18.06.2025.
//
import UIKit

extension UIViewController {
    func enableKeyboardDismissGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        swipeGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(swipeGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
