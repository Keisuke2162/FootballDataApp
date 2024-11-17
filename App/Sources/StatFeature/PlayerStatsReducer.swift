//
//  PlayerStatsReducer.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/23.
//

import API
import Foundation
import ComposableArchitecture
import Entities
import SwiftUI
import Utilities

@Reducer
public struct PlayerStatsReducer : Sendable {
  @ObservableState
  public struct State: Equatable {
    public let leagueType: LeagueType
    public let statType: StatType
    public var topScorerStats: [PlayerStats] = []
    
    public init(leagueType: LeagueType, statType: StatType) {
      self.leagueType = leagueType
      self.statType = statType
    }
  }

  public enum Action {
    case fetchTopScorer
    case topScorerResponse(Result<[PlayerStats], Error>)
  }
  
  @Dependency(\.statsAPIClient) var statsAPIClient
  @AppStorage(.useJSON) var isUseJson

  private enum CancelID { case stats }
  
  public init() {
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .fetchTopScorer:
        return .run { [leagueType = state.leagueType, statsType = state.statType] send in
          await send(.topScorerResponse(Result {
            switch statsType {
            case .topScorers:
              try await self.statsAPIClient.getTopScorers(leagueType, isUseJson)
            case .topAssists:
              try await self.statsAPIClient.getTopAssists(leagueType, isUseJson)
            }
          }))
        }
        .cancellable(id: CancelID.stats)
      case .topScorerResponse(.failure):
        return .none
      case let .topScorerResponse(.success(response)):
        state.topScorerStats = response
        return .none
      }
    }
  }
}

public struct PlayerStatsView: View {
  @Bindable var store: StoreOf<PlayerStatsReducer>
  
  public var body: some View {
    NavigationStack {
      List {
        ForEach(Array(store.topScorerStats.enumerated()), id: \.offset) { index, item in
          PlayerStatsListCell(statType: store.state.statType, playerStatsItem: item, order: index)
            .listRowBackground(Color.clear)
        }
        .listRowSeparator(.hidden)
        Spacer().frame(height: 120).listRowBackground(EmptyView())
          .listRowSeparator(.hidden)
      }
      .padding(.top, 16)
      .scrollContentBackground(.hidden)
      .background(store.state.leagueType.themaColor)
      .listStyle(.plain)
    }
    .task {
      do {
        try await Task.sleep(for: .milliseconds(300))
        await store.send(.fetchTopScorer).finish()
      } catch {}
    }
  }
}
