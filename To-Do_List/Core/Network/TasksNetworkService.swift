//
//  TasksNetworkService.swift
//  To-Do_List
//
//  Created by Павел Калинин on 19.06.2025.
//
import Foundation

protocol TasksNetworkServiceProtocol {
    func getTasks(completion: @escaping (Result<[TaskDTO], Error>) -> Void)
}

final class TasksNetworkService: TasksNetworkServiceProtocol {
    func getTasks(completion: @escaping (Result<[TaskDTO], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            DispatchQueue.main.async {
                completion(.failure(APIError.invalidURL))
            }
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            DispatchQueue.main.async {
                if let urlError = error as? URLError {
                    if urlError.code == .notConnectedToInternet {
                        completion(.failure(APIError.noInternetConnection))
                    } else {
                        completion(.failure(APIError.unknown(urlError)))
                    }
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(APIError.invalidResponse))
                    return
                }
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    completion(.failure(APIError.httpError(statusCode: httpResponse.statusCode)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(APIError.noData))
                    return
                }
                
                do {
                    let decoded = try JSONDecoder().decode(TaskResponse.self, from: data)
                    completion(.success(decoded.todos))
                } catch {
                    completion(.failure(APIError.decodingError(underlying: error)))
                }
            }
        }.resume()
    }
}
