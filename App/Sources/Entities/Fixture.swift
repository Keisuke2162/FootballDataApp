//
//  Fixture.swift
//  FootballDataManager
//
//  Created by Kei on 2023/10/09.
//

import Extensions
import Foundation

public struct FixturesItem: Codable {
  public let response: [Fixture]
  
  public var groupedItems: [String: [Fixture]] {
    Dictionary(grouping: response) { item in
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      return dateFormatter.string(from: item.fixture.date)
    }
  }
  
  public var dateKeys: [String] {
    groupedItems.keys.sorted()
  }
}

public struct Fixture: Identifiable, Codable, Equatable {
  public static func == (lhs: Fixture, rhs: Fixture) -> Bool {
    lhs.id == rhs.id
  }
  public var id: Int {
    fixture.id
  }
  public let fixture: FixtureItem
  public let teams: FixtureTeams
  public let goals: FixtureGoals

  public init(fixture: FixtureItem, teams: FixtureTeams, goals: FixtureGoals) {
    self.fixture = fixture
    self.teams = teams
    self.goals = goals
  }
}

public struct FixtureItem: Codable {
  public let id: Int
  public let date: Date
  public let status: FixtureStatus
}

public struct FixtureStatus: Codable {
  public let short: String
}

public struct FixtureTeams: Codable {
  public let home: FixtureTeam
  public let away: FixtureTeam
}

public struct FixtureTeam: Codable, Sendable {
  public let id: Int
  public let name: String
  public let logo: String
  public let winner: Bool?
}

public struct FixtureGoals: Codable {
  public let home: Int?
  public let away: Int?
}

public struct FixtureScore: Codable {
  public let halftime: FixtureGoals
  public let fulltime: FixtureGoals
  public let extratime: FixtureGoals
  public let penalty: FixtureGoals
  public var secondHalf: FixtureGoals {
    guard let halftimeHome = halftime.home, let fulltimeHome =  fulltime.home , let halftimeAway = halftime.away, let fulltimeAway = fulltime.away else { return .init(home: nil, away: nil) }
    return .init(home: fulltimeHome - halftimeHome, away: fulltimeAway - halftimeAway)
  }
}

//// MARK: - Mock
//extension FixturesItem {
//    public static let mock = Self(
//        response: [.mock]
//    )
//}
//
//extension Fixture {
//  public static let mock = Self(
//        fixture: .mock,
//        teams: .mock,
//        goals: .mock)
//}
//
//extension FixtureItem {
//  public static let mock = Self(
//        id: 1153775,
//        date: "2024-02-23T05:00:00+00:00".toDate()!,
//        status: .mock
//    )
//}
//
//extension FixtureStatus {
//  public static let mock = Self(
//        short: "FT"
//    )
//}
//extension FixtureTeams {
//  public static let mock = Self(
//        home: .mockHome,
//        away: .mockAway
//    )
//}
//
//extension FixtureTeam {
//  public static let mockHome = Self(
//        id: 282,
//        name: "Sanfrecce Hiroshima",
//        logo: "https://media.api-sports.io/football/teams/282.png",
//        winner: true
//    )
//  public static let mockAway = Self(
//        id: 287,
//        name: "Urawa",
//        logo: "https://media.api-sports.io/football/teams/287.png",
//        winner: false
//    )
//}
//
//extension FixtureGoals {
//  public static let mock = Self(
//        home: 2,
//        away: 0
//    )
//  public static let halftimeMock = Self(
//        home: 1,
//        away: 0
//    )
//  public static let fulltime = Self(
//        home: 2,
//        away: 0
//    )
//  public static let extratime = Self(
//        home: nil,
//        away: nil
//    )
//  public static let penalty = Self(
//        home: nil,
//        away: nil
//    )
//}
//
//extension FixtureScore {
//  public static let mock = Self(
//        halftime: .halftimeMock,
//        fulltime: .fulltime,
//        extratime: .extratime,
//        penalty: .penalty
//    )
//}
