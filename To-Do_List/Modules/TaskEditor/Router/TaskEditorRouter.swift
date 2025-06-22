//
//  MainRouterInput.swift
//  To-Do_List
//
//  Created by Павел Калинин on 19.06.2025.
//
import UIKit

protocol TaskEditorRouterInput: AnyObject {}

final class TaskEditorRouter: TaskEditorRouterInput {
    weak var vc: UIViewController?
    
}
