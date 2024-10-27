//
//  Fixture.swift
//  FootballDataManager
//
//  Created by Kei on 2023/10/09.
//

import Foundation

struct FixturesItem: Codable {
    let response: [Fixture]

    var groupedItems: [String: [Fixture]] {
        Dictionary(grouping: response) { item in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.string(from: item.fixture.date)
        }
    }

    var dateKeys: [String] {
        groupedItems.keys.sorted()
    }
}

struct Fixture: Codable, Equatable, Identifiable, Sendable {
    static func == (lhs: Fixture, rhs: Fixture) -> Bool {
        lhs.id == rhs.id
    }
    var id: Int {
        fixture.id
    }
    let fixture: FixtureItem
    let teams: FixtureTeams
    let goals: FixtureGoals
}

struct FixtureItem: Codable {
    let id: Int
    let date: Date
    let status: FixtureStatus
}

struct FixtureStatus: Codable {
    let short: String
}

struct FixtureTeams: Codable {
    let home: FixtureTeam
    let away: FixtureTeam
}

struct FixtureTeam: Codable {
    let id: Int
    let name: String
    let logo: String
    let winner: Bool?
}

struct FixtureGoals: Codable {
    let home: Int?
    let away: Int?
}

struct FixtureScore: Codable {
    let halftime: FixtureGoals
    let fulltime: FixtureGoals
    let extratime: FixtureGoals
    let penalty: FixtureGoals
    var secondHalf: FixtureGoals {
        guard let halftimeHome = halftime.home, let fulltimeHome =  fulltime.home , let halftimeAway = halftime.away, let fulltimeAway = fulltime.away else { return .init(home: nil, away: nil) }
        return .init(home: fulltimeHome - halftimeHome, away: fulltimeAway - halftimeAway)
    }
}

// MARK: - Mock
extension FixturesItem {
    static let mock = Self(
        response: [.mock]
    )
}

extension Fixture {
    static let mock = Self(
        fixture: .mock,
        teams: .mock,
        goals: .mock)
}

extension FixtureItem {
    static let mock = Self(
        id: 1153775,
        date: "2024-02-23T05:00:00+00:00".toDate()!,
        status: .mock
    )
}

extension FixtureStatus {
    static let mock = Self(
        short: "FT"
    )
}
extension FixtureTeams {
    static let mock = Self(
        home: .mockHome,
        away: .mockAway
    )
}

extension FixtureTeam {
    static let mockHome = Self(
        id: 282,
        name: "Sanfrecce Hiroshima",
        logo: "https://media.api-sports.io/football/teams/282.png",
        winner: true
    )
    static let mockAway = Self(
        id: 287,
        name: "Urawa",
        logo: "https://media.api-sports.io/football/teams/287.png",
        winner: false
    )
}

extension FixtureGoals {
    static let mock = Self(
        home: 2,
        away: 0
    )
    static let halftimeMock = Self(
        home: 1,
        away: 0
    )
    static let fulltime = Self(
        home: 2,
        away: 0
    )
    static let extratime = Self(
        home: nil,
        away: nil
    )
    static let penalty = Self(
        home: nil,
        away: nil
    )
}

extension FixtureScore {
    static let mock = Self(
        halftime: .halftimeMock,
        fulltime: .fulltime,
        extratime: .extratime,
        penalty: .penalty
    )
}
