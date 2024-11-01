//
//  APIError.swift
//  FootballDataManager
//
//  Created by Kei on 2023/10/01.
//

import Foundation

public enum APIError: Error {
    case invalidURL
    case networkError
    case noneValue
    case unknown

    public var title: String {
        switch self {
        case .noneValue:
            return "noneValue"
        case .invalidURL:
            return "invalidURL"
        case .networkError:
            return "networkError"
        default:
            return "unknown"
        }
    }
}
