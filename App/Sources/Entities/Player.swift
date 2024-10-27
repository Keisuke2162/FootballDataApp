//
//  Player.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/21.
//

import Foundation

enum StatType: CaseIterable, Equatable {
    case topScorers
    case topAssists

    var title: String {
        switch self {
        case .topScorers:
            "Top Scorers"
        case .topAssists:
            "Top Assists"
        }
    }
}

struct PlayerStatsItem: Codable {
    let response: [PlayerStats]
}

struct PlayerStats: Codable, Equatable, Identifiable, Sendable {
    static func == (lhs: PlayerStats, rhs: PlayerStats) -> Bool {
        lhs.id == rhs.id
    }

    var id: Int {
        player.id
    }
    let player: Player
    let statistics: [Statistics]
}

struct Player: Codable {
    let id: Int
    let name: String
    let imageURL: URL?
}

struct Statistics: Codable, Identifiable, Sendable {
    var id: Int {
        team.id
    }
    let team: Team
    let goals: Goals
}

struct Goals: Codable {
    let total: Int?
    let assists: Int?
}
