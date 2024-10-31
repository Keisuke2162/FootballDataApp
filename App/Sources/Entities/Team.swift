//
//  Team.swift
//  FootballDataManager
//
//  Created by Kei on 2023/10/01.
//

import Foundation

public struct Team: Codable, Sendable {
  public let id: Int
  public let name: String
  public let logo: String
}
