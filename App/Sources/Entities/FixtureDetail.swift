//
//  FixtureDetail.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/25.
//

import Foundation

struct FixtureDetailItem: Codable {
    let response: [FixtureDetail]
}

struct FixtureDetail: Codable, Equatable, Identifiable, Sendable {
    static func == (lhs: FixtureDetail, rhs: FixtureDetail) -> Bool {
        lhs.id == rhs.id
    }

    var id: Int {
        team.id
    }
    let team: FixtureTeam
    let statistics: [Statictics]

    var shotsOnGoal: String {
        statistics.first(where: { $0.type == .shotsOnGoal })?.statisticValue.value ?? "-"
    }
    var totalShots: String {
        statistics.first(where: { $0.type == .totalShots })?.statisticValue.value ?? "-"
    }
    var fouls: String {
        statistics.first(where: { $0.type == .fouls })?.statisticValue.value ?? "-"
    }
    var cornerKicks: String {
        statistics.first(where: { $0.type == .cornerKicks })?.statisticValue.value ?? "-"
    }
    var offsides: String {
        statistics.first(where: { $0.type == .offsides })?.statisticValue.value ?? "-"
    }
    var yellowCards: String {
        statistics.first(where: { $0.type == .yellowCards })?.statisticValue.value ?? "-"
    }
    var redCards: String {
        statistics.first(where: { $0.type == .redCards })?.statisticValue.value ?? "-"
    }
    var ballPossession: String {
        statistics.first(where: { $0.type == .ballPossession })?.statisticValue.value ?? "-"
    }
    var expectedGoals: String {
        statistics.first(where: { $0.type == .expectedGoals })?.statisticValue.value ?? "-"
    }
}

struct Statictics: Codable {
    let type: StatisticType
    let statisticValue: StatisticValue

    enum CodingKeys: String, CodingKey {
        case type
        case statisticValue = "value"
    }
}

enum StatisticType: String, Codable {
    case shotsOnGoal = "Shots on Goal"
    case shotsOffGoal = "Shots off Goal"
    case totalShots = "Total Shots"
    case blockedShots = "Blocked Shots"
    case shotsInsideBox = "Shots insidebox"
    case shotsOutsideBox = "Shots outsidebox"
    case fouls = "Fouls"
    case cornerKicks = "Corner Kicks"
    case offsides = "Offsides"
    case ballPossession = "Ball Possession"
    case yellowCards = "Yellow Cards"
    case redCards = "Red Cards"
    case goalkeeperSaves = "Goalkeeper Saves"
    case totalPasses = "Total passes"
    case passesAccurate = "Passes accurate"
    case passesPercentage = "Passes %"
    case expectedGoals = "expected_goals"
}

struct StatisticValue: Codable {
    let value: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self.value = String(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self.value = stringValue
        } else {
            self.value = nil
        }
    }
}
