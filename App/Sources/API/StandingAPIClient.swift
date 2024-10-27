//
//  StandingAPIClient.swift
//  FootballDataManager
//
//  Created by Kei on 2023/10/01.
//

import ComposableArchitecture
import Foundation

@DependencyClient
struct StandingClient {
    var getStanding: @Sendable (_ type: LeagueType) async throws -> [Standing]
}

extension StandingClient: TestDependencyKey {
//    static let previewValue = Self(getStanding: { _ in [.mock] })
    static let previewValue = Self(
        getStanding: { type in
            do {
                return try await liveValue.getStanding(type)
            } catch { return [] }
        }
    )
    static var testValue: StandingClient = Self()
}

extension DependencyValues {
    var standingClient: StandingClient {
        get { self[StandingClient.self] }
        set { self[StandingClient.self] = newValue }
    }
}

extension StandingClient: DependencyKey {
    static let liveValue: StandingClient = StandingClient(
        getStanding: { type in
            var components = URLComponents(string: "https://v3.football.api-sports.io/standings")!
            components.queryItems = [
                .init(name: "season", value: "2023"),
                .init(name: "league", value: type.id)
            ]
            // MARK: - API Request
//            var request = URLRequest(url: components.url!)
//            request.setValue("", forHTTPHeaderField: "x-rapidapi-key")
//            request.httpMethod = "GET"
//            
//            let (data, _) = try await URLSession.shared.data(from: request.url!)
//            do {
//                let item = try JSONDecoder().decode(StandingsItem.self, from: data)
//                guard let items = item.response.first?.league.standings.first else {
//                    throw APIError.unknown
//                }
//                return items
//            } catch {
//                throw APIError.unknown
//            }
            
            // MARK: - Local JSON File
            // JSONファイルからモックデータ読み込み
            guard let fileURL = Bundle.main.url(forResource: type.standingResource, withExtension: "json") else {
                throw APIError.unknown
            }

            do {
                let data = try Data(contentsOf: fileURL)
                let item = try JSONDecoder().decode(StandingsItem.self, from: data)
                guard let items = item.response.first?.league.standings.first else {
                    throw APIError.unknown
                }
                return items
            } catch {
                throw APIError.unknown
            }
        }
    )
}
