//
//  StandingAPIClient.swift
//  FootballDataManager
//
//  Created by Kei on 2023/10/01.
//

import Entities
import Dependencies
import DependenciesMacros
import XCTestDynamicOverlay
import Foundation

@DependencyClient
public struct StandingClient : Sendable {
  public var getStanding: @Sendable (_ type: LeagueType, _ isUseJSON: Bool) async throws -> [Standing]
}

extension StandingClient: TestDependencyKey {
  public static let previewValue = Self()
  public static let testValue: StandingClient = Self()
}

extension DependencyValues {
  public var standingClient: StandingClient {
    get { self[StandingClient.self] }
    set { self[StandingClient.self] = newValue }
  }
}

extension StandingClient: DependencyKey {
  public static let liveValue: StandingClient = StandingClient(
    getStanding: { type, isUseJSON in
      var components = URLComponents(string: "https://v3.football.api-sports.io/standings")!
      components.queryItems = [
        .init(name: "season", value: "2022"),
        .init(name: "league", value: type.id)
      ]
      
      var request = URLRequest(url: components.url!)
      request.setValue("14a6551f30510e7202fcb46ff94fc54f", forHTTPHeaderField: "x-apisports-key")
      request.httpMethod = "GET"
      
      let (data, _) = try await URLSession.shared.data(for: request)
      
      // print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
      do {
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
