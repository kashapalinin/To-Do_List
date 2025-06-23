//
//  TaskServiceTests.swift
//  To-Do_List
//
//  Created by Павел Калинин on 23.06.2025.
//


import XCTest
import Combine
@testable import To_Do_List

final class TaskServiceTests: XCTestCase {
    var sut: TaskServiceProtocol!
    var mockNetwork: MockTasksNetworkService!
    var mockCoreData: MockCoreDataManager!
    var userDefaults: UserDefaults!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockNetwork = MockTasksNetworkService()
        mockCoreData = MockCoreDataManager()
        userDefaults = UserDefaults(suiteName: "TestDefaults")
        userDefaults.removePersistentDomain(forName: "TestDefaults")
        cancellables = []
        sut = TaskService(network: mockNetwork, storage: mockCoreData, userDefaults: userDefaults)
    }

    override func tearDown() {
        sut = nil
        cancellables = nil
        userDefaults.removePersistentDomain(forName: "TestDefaults")
        super.tearDown()
    }

    func test_getTasks_fromNetwork_thenSavesToCoreData() {
        let expectation = XCTestExpectation(description: "Tasks loaded from network")

        mockNetwork.result = .success([
            TaskDTO(id: 1, todo: "Test", completed: false, userID: 0)
        ])
        
        sut.tasksPublisher
            .dropFirst()
            .sink { tasks in
                XCTAssertEqual(tasks.count, 1)
                XCTAssertEqual(tasks.first?.title, "Test")
                XCTAssertEqual(self.mockCoreData.savedTasks.count, 1)
                XCTAssertTrue(self.userDefaults.bool(forKey: "hasLoadedTasks"))
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.getTasks()

        wait(for: [expectation], timeout: 1)
    }

    func test_toggleCompletion_flipsIsCompleted() {
        let task = Task(id: "123", title: "Toggle Me", description: "", date: Date(), isCompleted: false)
        sut.save(task: task)

        let expectation = expectation(description: "Task updated emitted")
        sut.taskDidUpdate
            .sink { updated in
                XCTAssertTrue(updated.isCompleted)
                XCTAssertEqual(updated.id, task.id)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.toggleCompletion(id: "123")
        wait(for: [expectation], timeout: 1)

        let updated = mockCoreData.updatedTasks.first
        XCTAssertTrue(updated?.isCompleted ?? false)
    }

    func test_searchTasks_filtersCorrectly() {
        sut.save(task: Task(id: "1", title: "Buy milk", description: "", date: Date(), isCompleted: false))
        sut.save(task: Task(id: "2", title: "Buy bread", description: "", date: Date(), isCompleted: false))
        sut.save(task: Task(id: "3", title: "Go gym", description: "", date: Date(), isCompleted: false))

        let expectation = expectation(description: "Search works")
        sut.tasksPublisher
            .dropFirst()
            .sink { result in
                XCTAssertEqual(result.count, 2)
                XCTAssertTrue(result.allSatisfy { $0.title.contains("Buy") })
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.searchTasks(by: "buy")
        wait(for: [expectation], timeout: 1)
    }

    func test_deleteTask_removesFromListAndCoreData() {
        // Arrange
        let task = Task(id: "1", title: "To delete", description: "", date: Date(), isCompleted: false)
        sut.save(task: task)

        // Act
        sut.deleteTask(id: "1")

        // Assert
        XCTAssertTrue(mockCoreData.deletedTaskIds.contains("1"))

        let expectation = expectation(description: "Tasks reflect deletion")

        sut.tasksPublisher
            .dropFirst()
            .sink { tasks in
                XCTAssertFalse(tasks.contains(where: { $0.id == "1" }))
                expectation.fulfill()
            }
            .store(in: &cancellables)

        sut.searchTasks(by: "")

        wait(for: [expectation], timeout: 2)
    }


    func test_updateTask_modifiesTask() {
        let expectation = expectation(description: "Task updated in publisher")
        let original = Task(id: "1", title: "Old Title", description: "", date: Date(), isCompleted: false)
        sut.save(task: original)
        
        let updated = Task(id: "1", title: "New Title", description: "", date: Date(), isCompleted: true)
        
        sut.tasksPublisher
            .dropFirst()
            .sink { tasks in
                let task = tasks.first { $0.id == "1" }
                XCTAssertEqual(task?.title, "New Title")
                XCTAssertTrue(self.mockCoreData.updatedTasks.contains(where: { $0.title == "New Title" }))
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        sut.update(task: updated)
        
        wait(for: [expectation], timeout: 1)
    }
}
