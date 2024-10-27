//
//  StatsAPIClient.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/21.
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct StatsAPIClient {
    var getTopScorers: @Sendable (_ type: LeagueType) async throws -> [PlayerStats]
    var getTopAssists: @Sendable (_ type: LeagueType) async throws -> [PlayerStats]
}

extension StatsAPIClient: TestDependencyKey {
    static let previewValue = Self(
        getTopScorers: { type in
            do {
                return try await liveValue.getTopScorers(type)
            } catch { return .init([]) }
        },
        getTopAssists: { type in
            do {
                return try await liveValue.getTopAssists(type)
            } catch { return .init([]) }
        }
    )
    static let testValue: StatsAPIClient = Self()
}

extension DependencyValues {
    var statsAPIClient: StatsAPIClient {
        get { self[StatsAPIClient.self] }
        set { self[StatsAPIClient.self] = newValue }
    }
}

extension StatsAPIClient: DependencyKey {
    static let liveValue: StatsAPIClient = StatsAPIClient(
        getTopScorers: { type in
            var components = URLComponents(string: "https://v3.football.api-sports.io/fixtures")!
            components.queryItems = [
                .init(name: "season", value: "2023"),
                .init(name: "league", value: type.id)
            ]
            // MARK: - Local JSON File
            guard let fileURL = Bundle.main.url(forResource: type.topScorerResource, withExtension: "json") else {
                throw APIError.unknown
            }

            do {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let item = try decoder.decode(PlayerStatsItem.self, from: data)
                return item.response
            } catch {
                throw APIError.unknown
            }
        },
        getTopAssists: { type in
            var components = URLComponents(string: "https://v3.football.api-sports.io/fixtures")!
            components.queryItems = [
                .init(name: "season", value: "2023"),
                .init(name: "league", value: type.id)
            ]
            // MARK: - API Request
            // MARK: - Local JSON File
            guard let fileURL = Bundle.main.url(forResource: type.topAssistResource, withExtension: "json") else {
                throw APIError.unknown
            }

            do {
                let data = try Data(contentsOf: fileURL)
                let decoder = JSONDecoder()
                let item = try decoder.decode(PlayerStatsItem.self, from: data)
                return item.response
            } catch {
                throw APIError.unknown
            }
        }
    )
}
