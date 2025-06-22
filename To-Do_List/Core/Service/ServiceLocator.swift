//
//  ServiceLocator.swift
//  To-Do_List
//
//  Created by Павел Калинин on 19.06.2025.
//

final class ServiceLocator {
    static let shared = ServiceLocator()
    private var services: [String: Any] = [:]
    
    private init() {}
    
    func register<T>(_ service: T) {
        services[String(describing: T.self)] = service
    }
    
    func resolve<T>() -> T {
        let service = services[String(describing: T.self)]
        guard let service = service as? T else {
            fatalError("Service \(T.self) not registered!")
        }
        return service
    }
}

extension ServiceLocator {
    var taskService: TaskService { resolve() }
    var coreDataManager: CoreDataManager { resolve() }
}
