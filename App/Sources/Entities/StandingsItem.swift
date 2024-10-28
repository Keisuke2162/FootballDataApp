//
//  StandingsItem.swift
//  FootballDataManager
//
//  Created by Kei on 2023/10/01.
//

import Foundation

public struct StandingsItem: Codable {
  public let response: [StandingResponse]
}

public struct StandingResponse: Codable {
  public let league: LeagueItem
}

public struct LeagueItem: Codable {
  public let standings: [[Standing]]
}

public struct Standing: Codable, Equatable, Identifiable, Sendable {
  public static func == (lhs: Standing, rhs: Standing) -> Bool {
    lhs.id == rhs.id
  }
  
  public var id: Int {
    team.id
  }
  public let rank: Int
  public let team: TeamInfo
  public let points: Int
  public let goalsDiff: Int
  public let all: AllGameInformation

  public init(rank: Int, team: TeamInfo, points: Int, goalsDiff: Int, all: AllGameInformation) {
    self.rank = rank
    self.team = team
    self.points = points
    self.goalsDiff = goalsDiff
    self.all = all
  }
}

public struct TeamInfo: Codable, Equatable, Identifiable, Sendable {
  public let id: Int
  public let name: String
  public let logo: String
}

public struct AllGameInformation: Codable, Sendable {
  public let played: Int
  public let win: Int
  public let draw: Int
  public let lose: Int
}

//  
//extension Standing {
//  public static let mock = Self(
//    rank: 1,
//    team: .mock,
//    points: 30,
//    goalsDiff: 15,
//    all: .mock
//  )
//}
//
//extension LeagueItem {
//  public static let mock = Self(
//    standings: [[.mock]]
//  )
//}
//
//extension StandingResponse {
//  public static let mock = Self(
//    league: .mock
//  )
//}
//
//extension StandingsItem {
//  public static let mock = Self(
//    response: [.mock]
//  )
//}
