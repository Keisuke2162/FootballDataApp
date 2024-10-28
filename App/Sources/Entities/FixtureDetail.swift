//
//  FixtureDetail.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/25.
//

import Foundation

public struct FixtureDetailItem: Codable {
  public let response: [FixtureDetail]
}

public struct FixtureDetail: Codable, Equatable, Identifiable, Sendable {
  public static func == (lhs: FixtureDetail, rhs: FixtureDetail) -> Bool {
    lhs.id == rhs.id
  }
  
  public var id: Int {
    team.id
  }
  public let team: FixtureTeam
  public let statistics: [Statictics]
  
  public init(team: FixtureTeam, statistics: [Statictics]) {
    self.team = team
    self.statistics = statistics
  }
  
  public var shotsOnGoal: String {
    statistics.first(where: { $0.type == .shotsOnGoal })?.statisticValue.value ?? "-"
  }
  public var totalShots: String {
    statistics.first(where: { $0.type == .totalShots })?.statisticValue.value ?? "-"
  }
  public var fouls: String {
    statistics.first(where: { $0.type == .fouls })?.statisticValue.value ?? "-"
  }
  public var cornerKicks: String {
    statistics.first(where: { $0.type == .cornerKicks })?.statisticValue.value ?? "-"
  }
  public var offsides: String {
    statistics.first(where: { $0.type == .offsides })?.statisticValue.value ?? "-"
  }
  public var yellowCards: String {
    statistics.first(where: { $0.type == .yellowCards })?.statisticValue.value ?? "-"
  }
  public var redCards: String {
    statistics.first(where: { $0.type == .redCards })?.statisticValue.value ?? "-"
  }
  public var ballPossession: String {
    statistics.first(where: { $0.type == .ballPossession })?.statisticValue.value ?? "-"
  }
  public var expectedGoals: String {
    statistics.first(where: { $0.type == .expectedGoals })?.statisticValue.value ?? "-"
  }
}

public struct Statictics: Codable, Sendable {
  public let type: StatisticType
  public let statisticValue: StatisticValue
  
  public enum CodingKeys: String, CodingKey {
    case type
    case statisticValue = "value"
  }

  public init(type: StatisticType, statisticValue: StatisticValue) {
    self.type = type
    self.statisticValue = statisticValue
  }
}

public enum StatisticType: String, Codable, Sendable {
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

public struct StatisticValue: Codable, Sendable {
  public let value: String?
  
  public init(from decoder: Decoder) throws {
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
