//
//  Player.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/21.
//

import Foundation

public enum StatType: CaseIterable, Equatable, Sendable {
    case topScorers
    case topAssists

  public var title: String {
        switch self {
        case .topScorers:
            "Top Scorers"
        case .topAssists:
            "Top Assists"
        }
    }
}

public struct PlayerStatsItem: Codable {
  public let response: [PlayerStats]
}

public struct PlayerStats: Codable, Equatable, Identifiable, Sendable {
  public static func == (lhs: PlayerStats, rhs: PlayerStats) -> Bool {
        lhs.id == rhs.id
    }

  public var id: Int {
        player.id
    }
  public let player: Player
  public let statistics: [Statistics]
}

public struct Player: Codable, Sendable {
  public let id: Int
  public let name: String
  public let imageURL: URL?
}

public struct Statistics: Codable, Identifiable, Sendable {
  public var id: Int {
        team.id
    }
  public let team: Team
  public let goals: Goals
}

public struct Goals: Codable, Sendable {
  public let total: Int?
  public let assists: Int?
}
