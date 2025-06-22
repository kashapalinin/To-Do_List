//
//  MainAssembly.swift
//  To-Do_List
//
//  Created by Павел Калинин on 18.06.2025.
//
import UIKit

final class MainAssembly {
    static func build() -> UIViewController {
        let vc = MainViewController()
        let presenter = MainPresenter()
        let router = MainRouter()
        let interactor = MainInteractor()

        vc.presenter = presenter
        presenter.view = vc
        presenter.interactor = interactor
        presenter.router = router
        router.vc = vc
        interactor.presenter = presenter
        return vc
    }
}
