//
//  CoreDataManager.swift
//  To-Do_List
//
//  Created by Павел Калинин on 19.06.2025.
//
import CoreData

final class CoreDataManager {

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "To_Do_List")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func fetchAllTasks() -> [Task] {
        let fetchRequest = TaskEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        do {
            return try viewContext.fetch(fetchRequest).compactMap { Task(from: $0) }
        } catch {
            return []
        }
    }

    func saveAll(_ tasks: [Task]) {
        tasks.forEach {
            TaskEntity(context: viewContext).update(from: $0)
        }
        try? viewContext.save()
    }

    func add(task: Task) {
        let entity = TaskEntity(context: viewContext)
        entity.update(from: task)
        saveContext()
    }

    func deleteTask(by id: String) {
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let tasks = try viewContext.fetch(fetchRequest)
            for task in tasks {
                viewContext.delete(task)
            }
            saveContext()
        } catch {
            print("Failed to delete task: \(error)")
        }
    }

    func updateTask(_ task: Task) {
        let request = TaskEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", task.id as CVarArg)

        do {
            let results = try viewContext.fetch(request)
            if let entity = results.first {
                entity.title = task.title
                entity.isCompleted = task.isCompleted
                entity.body = task.description
                entity.date = task.date
                try viewContext.save()
            }
        } catch {
            print("Ошибка при обновлении задачи: \(error)")
        }
    }
}
