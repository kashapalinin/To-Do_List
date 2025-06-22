//
//  APIError.swift
//  To-Do_List
//
//  Created by Павел Калинин on 22.06.2025.
//
import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case noData
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(underlying: Error)
    case noInternetConnection
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Недопустимый URL."
        case .noData:
            return "Сервер не вернул данные."
        case .invalidResponse:
            return "Неверный формат ответа от сервера."
        case .httpError(let code):
            return "Ошибка HTTP: \(code)"
        case .decodingError:
            return "Ошибка при обработке данных."
        case .noInternetConnection:
            return "Нет подключения к интернету."
        case .unknown(let error):
            return "Неизвестная ошибка: \(error.localizedDescription)"
        }
    }
}
