//
//  StandingsItem.swift
//  FootballDataManager
//
//  Created by Kei on 2023/10/01.
//

import Foundation

struct StandingsItem: Codable {
    let response: [StandingResponse]
}

struct StandingResponse: Codable {
    let league: LeagueItem
}

struct LeagueItem: Codable {
    let standings: [[Standing]]
}

struct Standing: Codable, Equatable, Identifiable, Sendable {
    static func == (lhs: Standing, rhs: Standing) -> Bool {
        lhs.id == rhs.id
    }

    var id: Int {
        team.id
    }
    let rank: Int
    let team: TeamInfo
    let points: Int
    let goalsDiff: Int
    let all: AllGameInformation
}

struct TeamInfo: Codable, Equatable, Identifiable, Sendable {
    let id: Int
    let name: String
    let logo: String
}

struct AllGameInformation: Codable {
    let played: Int
    let win: Int
    let draw: Int
    let lose: Int
}

// MARK: - Mock
extension AllGameInformation {
    static let mock = Self(
        played: 30,
        win: 10,
        draw: 5,
        lose: 15
    )
}

extension TeamInfo {
    static let mock = Self(
        id: 1,
        name: "Everton",
        logo: ""
    )
}

extension Standing {
    static let mock = Self(
        rank: 1,
        team: .mock,
        points: 30,
        goalsDiff: 15,
        all: .mock
    )
}

extension LeagueItem {
    static let mock = Self(
        standings: [[.mock]]
    )
}

extension StandingResponse {
    static let mock = Self(
        league: .mock
    )
}

extension StandingsItem {
    static let mock = Self(
        response: [.mock]
    )
}
