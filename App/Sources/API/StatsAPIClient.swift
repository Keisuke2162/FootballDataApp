//
//  StatsAPIClient.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/21.
//

import Entities
import Dependencies
import DependenciesMacros
import XCTestDynamicOverlay
import Foundation

@DependencyClient
public struct StatsAPIClient : Sendable {
  public var getTopScorers: @Sendable (_ type: LeagueType, _ isUseJSON: Bool) async throws -> [PlayerStats]
  public var getTopAssists: @Sendable (_ type: LeagueType, _ isUseJSON: Bool) async throws -> [PlayerStats]
}

// MEMO: Preview用のテストデータ。多分使ってない
extension StatsAPIClient: TestDependencyKey {
  public static let previewValue = Self(
    getTopScorers: { type, isUseJSON in
      do {
        return try await liveValue.getTopScorers(type, isUseJSON)
      } catch { return .init([]) }
    },
    getTopAssists: { type, isUseJSON in
      do {
        return try await liveValue.getTopAssists(type, isUseJSON)
      } catch { return .init([]) }
    }
  )
  public static let testValue: StatsAPIClient = Self()
}

extension DependencyValues {
  public var statsAPIClient: StatsAPIClient {
    get { self[StatsAPIClient.self] }
    set { self[StatsAPIClient.self] = newValue }
  }
}

extension StatsAPIClient: DependencyKey {
  public static let liveValue: StatsAPIClient = StatsAPIClient(
    getTopScorers: { type, isUseJSON in
      let data: Data
      
      if isUseJSON {
        guard let fileURL = Bundle.main.url(forResource: type.topScorerResource, withExtension: "json") else {
          throw APIError.unknown
        }
        data = try Data(contentsOf: fileURL)
      } else {
        var components = URLComponents(string: "https://v3.football.api-sports.io/players/topscorers")!
        components.queryItems = [
          .init(name: "season", value: "2022"),
          .init(name: "league", value: type.id)
        ]
        var request = URLRequest(url: components.url!)
        request.setValue("14a6551f30510e7202fcb46ff94fc54f", forHTTPHeaderField: "x-apisports-key")
        request.httpMethod = "GET"
        
        (data, _) = try await URLSession.shared.data(for: request)
      }
      
      do {
        let decoder = JSONDecoder()
        let item = try decoder.decode(PlayerStatsItem.self, from: data)
        return item.response
      } catch {
        throw APIError.unknown
      }
    },
    getTopAssists: { type, isUseJSON in
      let data: Data
      
      if isUseJSON {
        guard let fileURL = Bundle.main.url(forResource: type.topAssistResource, withExtension: "json") else {
          throw APIError.unknown
        }
        data = try Data(contentsOf: fileURL)
      } else {
        var components = URLComponents(string: "https://v3.football.api-sports.io/players/topassists")!
        components.queryItems = [
          .init(name: "season", value: "2022"),
          .init(name: "league", value: type.id)
        ]
        var request = URLRequest(url: components.url!)
        request.setValue("14a6551f30510e7202fcb46ff94fc54f", forHTTPHeaderField: "x-apisports-key")
        request.httpMethod = "GET"
        
        (data, _) = try await URLSession.shared.data(for: request)
      }
      
      do {
        let decoder = JSONDecoder()
        let item = try decoder.decode(PlayerStatsItem.self, from: data)
        return item.response
      } catch {
        throw APIError.unknown
      }
    }
  )
}
