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
  public var getStanding: @Sendable (_ type: LeagueType) async throws -> [Standing]
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
    getStanding: { type in
      var components = URLComponents(string: "https://v3.football.api-sports.io/standings")!
      components.queryItems = [
        .init(name: "season", value: "2023"),
        .init(name: "league", value: type.id)
      ]
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
