//
//  StandingListReducer.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/16.
//

import API
import Foundation
import ComposableArchitecture
import Entities
import SwiftUI

@Reducer
public struct StandingReducer : Sendable{
  @ObservableState
  public struct State: Equatable {
    public let leagueType: LeagueType
    public var standings: [Standing] = []
    
    public init(leagueType: LeagueType) {
      self.leagueType = leagueType
    }
  }
  
  public enum Action {
    case tapClubCell    // セルをタップ
    case fetchStandings
    case standingResponse(Result<[Standing], Error>)
  }
  
  @Dependency(\.standingClient) var standingClient
  private enum CancelID { case standing }
  
  public init() {
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .tapClubCell:      // Cellタップ時
        return .none
      case .fetchStandings:   // データ取得開始
        return .run { [leagueType = state.leagueType] send in
          await send(.standingResponse(Result { try await self.standingClient.getStanding(leagueType) }))
        }
        .cancellable(id: CancelID.standing)
      case .standingResponse(.failure):   // APIエラー時
        return .none
      case let .standingResponse(.success(response)): // データ取得正常終了時
        state.standings = response
        return .none
      }
    }
  }
}

public struct StandingView: View {
  @Bindable var store: StoreOf<StandingReducer>
  
  public init(store: StoreOf<StandingReducer>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStack {
      VStack {
        HStack(spacing: 8) {
          Spacer().frame(width: 16)
          Text("Pos")
            .font(.custom("SSportsD-Medium", size: 12))
            .frame(width: 24)
          Text("Club")
            .font(.custom("SSportsD-Medium", size: 12))
            .frame(width: 32)
            .padding(.leading, 46)
          Spacer()
          Text("P")
            .font(.custom("SSportsD-Medium", size: 12))
            .frame(width: 24)
          Text("GD")
            .font(.custom("SSportsD-Medium", size: 12))
            .frame(width: 24)
          Text("Pts")
            .font(.custom("SSportsD-Medium", size: 12))
            .frame(width: 24)
          Spacer().frame(width: 16)
        }
        .frame(height: 32)
        List {
          ForEach(store.standings) { standing in
            StandingCellView(standingItem: standing)
              .frame(height: 46)
              .listRowBackground(Color.clear)
          }
          Spacer().frame(height: 50).listRowBackground(EmptyView())
        }
        .scrollContentBackground(.hidden)
        .background(store.state.leagueType.themaColor)
        .listStyle(.grouped)
      }
      
    }
    .task {
      do {
        try await Task.sleep(for: .milliseconds(300))
        await store.send(.fetchStandings).finish()
      } catch {}
    }
  }
}
