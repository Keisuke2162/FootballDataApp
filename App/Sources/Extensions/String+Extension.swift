//
//  String+Extension.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/18.
//

import Foundation

extension String {
    func toDate() -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: self)
    }
}
