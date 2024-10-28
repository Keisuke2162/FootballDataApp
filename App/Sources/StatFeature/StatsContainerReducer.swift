//
//  StatsContainerReducer.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/23.
//

import ComposableArchitecture
import Foundation
import Entities
import SwiftUI

@Reducer
public struct StatsContainerReducer {
  @ObservableState
  public struct State: Equatable {
    
    public let leagueType: LeagueType
    public var selectedStatsType: StatType = .topScorers
    public var topScorerList = PlayerStatsReducer.State(leagueType: .england, statType: .topScorers)
    public var topAssistList = PlayerStatsReducer.State(leagueType: .england, statType: .topAssists)
    
    public init(leagueType: LeagueType) {
      self.leagueType = leagueType
    }
  }
  
  public enum Action {
    case selectedType(StatType)
    case updateLeagueType
    case topScorerList(PlayerStatsReducer.Action)
    case topAssistList(PlayerStatsReducer.Action)
  }
  
  public init() {
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.topScorerList, action: \.topScorerList) {
      PlayerStatsReducer()
    }
    Scope(state: \.topAssistList, action: \.topAssistList) {
      PlayerStatsReducer()
    }
    Reduce { state, action in
      switch action {
      case let .selectedType(type):
        state.selectedStatsType = type
        return .none
      case .updateLeagueType:
        state.topScorerList = .init(leagueType: state.leagueType, statType: .topScorers)
        state.topAssistList = .init(leagueType: state.leagueType, statType: .topAssists)
        return .run { send in
          await send(.topScorerList(.fetchTopScorer))
          await send(.topAssistList(.fetchTopScorer))
        }
      case .topScorerList:
        return .none
      case .topAssistList:
        return .none
      }
    }
  }
}

public struct StatsContainerView: View {
  @Bindable var store: StoreOf<StatsContainerReducer>

  public init(store: StoreOf<StatsContainerReducer>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStack {
      VStack(spacing: 0) {
        HStack(spacing: 0) {
          ForEach(StatType.allCases, id: \.self) { type in
            Button(action: {
              store.send(.selectedType(type))
            }, label: {
              VStack {
                Text(type.title)
                  .foregroundColor(store.state.selectedStatsType == type ? Color.white : Color.gray)
                  .font(.custom("SSportsD-Medium", size: 12))
                Rectangle()
                  .fill(store.state.selectedStatsType == type ? Color.white : Color.clear)
                  .frame(height: 4)
              }
            })
          }
        }
        TabView(selection: $store.selectedStatsType.sending(\.selectedType)) {
          PlayerStatsView(store: self.store.scope(state: \.topScorerList, action: \.topScorerList))
            .tag(StatType.topScorers)
            .toolbarBackground(.hidden, for: .tabBar)
          PlayerStatsView(store: self.store.scope(state: \.topAssistList, action: \.topAssistList))
            .tag(StatType.topAssists)
            .toolbarBackground(.hidden, for: .tabBar)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .animation(.easeInOut, value: store.state.selectedStatsType)
      }
      .background(store.state.leagueType.themaColor)
    }
  }
}
