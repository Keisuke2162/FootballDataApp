//
//  FixturesAPIClient.swift
//  FootballDataManager
//
//  Created by Kei on 2023/10/09.
//

import Entities
import Dependencies
import DependenciesMacros
import Utilities
import XCTestDynamicOverlay
import Foundation
import SwiftUI
import ComposableArchitecture

// MARK: Client
@DependencyClient
public struct FixturesClient : Sendable {
  public var getFixtures: @Sendable (_ type: LeagueType, _ isUseJSON: Bool) async throws -> FixturesItem
  public var getFixtureDetail: @Sendable (_ teamID: Int, _ fixtureID: Int, _ isHome: Bool, _ isUseJSON: Bool) async throws -> FixtureDetail
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
      getFixtures: { type, isUseJSON in
        var components = URLComponents(string: "https://v3.football.api-sports.io/fixtures")!
        components.queryItems = [
          .init(name: "season", value: "2022"),
          .init(name: "league", value: type.id)
        ]
        var request = URLRequest(url: components.url!)
        request.setValue("14a6551f30510e7202fcb46ff94fc54f", forHTTPHeaderField: "x-apisports-key")
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        do {
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
      getFixtureDetail: { teamID, fixtureID, isHome, isUseJSON in
        var components = URLComponents(string: "https://v3.football.api-sports.io/fixtures/statistics")!
        components.queryItems = [
          .init(name: "fixture", value: String(fixtureID)),
          .init(name: "team", value: String(teamID))
        ]

        var request = URLRequest(url: components.url!)
        request.setValue("14a6551f30510e7202fcb46ff94fc54f", forHTTPHeaderField: "x-apisports-key")
        request.httpMethod = "GET"
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        print(String(data: data, encoding: .utf8) ?? "Invalid JSON")
        
        do {
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
          throw APIError.unknown
        }
      }
    )
  }()
}
