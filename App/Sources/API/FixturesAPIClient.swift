//
//  FixturesAPIClient.swift
//  FootballDataManager
//
//  Created by Kei on 2023/10/09.
//

import Entities
import Dependencies
import DependenciesMacros
import XCTestDynamicOverlay
import Foundation

// MARK: Client
@DependencyClient
public struct FixturesClient : Sendable {
  public var getFixtures: @Sendable (_ type: LeagueType) async throws -> FixturesItem
  public var getFixtureDetail: @Sendable (_ teamID: Int, _ fixtureID: Int, _ isHome: Bool) async throws -> FixtureDetail
}

// MARK: TestKey
extension DependencyValues {
  public var fixtureClient: FixturesClient {
    get { self[FixturesClient.self] }
    set { self[FixturesClient.self] = newValue }
  }
}

extension FixturesClient: TestDependencyKey {
  public static let previewValue = Self()
  public static let testValue = Self()
}

// MARK: LiveKey
extension FixturesClient: DependencyKey {
  public static let liveValue: Self = {
    return Self(
      getFixtures: { type in
        var components = URLComponents(string: "https://v3.football.api-sports.io/fixtures")!
        //https://v3.football.api-sports.io/fixtures?season=2021&league=39
        components.queryItems = [
          .init(name: "season", value: "2023"),
          .init(name: "league", value: type.id)
        ]
        
        // MARK: - Local JSON File
        guard let fileURL = Bundle.main.url(forResource: type.fixturesResource, withExtension: "json") else {
          throw APIError.unknown
        }
        
        do {
          let data = try Data(contentsOf: fileURL)
          let decoder = JSONDecoder()
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
          decoder.dateDecodingStrategy = .formatted(dateFormatter)
          let item = try decoder.decode(FixturesItem.self, from: data)
          return item
        } catch {
          throw APIError.unknown
        }
      },
      getFixtureDetail: { teamID, fixtureID, isHome in
        let resource = isHome ? "football_api_statistics_2024_98_282" : "football_api_statistics_2024_98_287"
        guard let fileURL = Bundle.main.url(forResource: resource, withExtension: "json") else { throw APIError.unknown }
        do {
          let data = try Data(contentsOf: fileURL)
          let decoder = JSONDecoder()
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
          decoder.dateDecodingStrategy = .formatted(dateFormatter)
          let item = try decoder.decode(FixtureDetailItem.self, from: data)
          guard let response = item.response.first else {
            throw APIError.unknown
          }
          return response
        } catch {
          print("テスト4 \(error)")
          throw APIError.unknown
        }
      }
    )
  }()
}
