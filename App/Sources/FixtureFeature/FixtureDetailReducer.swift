//
//  FixtureDetailReducer.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/25.
//

import API
import Foundation
import ComposableArchitecture
import Entities
import Kingfisher
import SwiftUI
import Utilities

@Reducer
public struct FixtureDetailReducer : Sendable{
  @ObservableState
  public struct State: Equatable {
    let leagueType: LeagueType
    let fixture: Fixture
    var fixtureDetailHome: FixtureDetail?
    var fixtureDetailAway: FixtureDetail?
    
    public init(leagueType: LeagueType, fixture: Fixture, fixtureDetailHome: FixtureDetail? = nil, fixtureDetailAway: FixtureDetail? = nil) {
      self.leagueType = leagueType
      self.fixture = fixture
      self.fixtureDetailHome = fixtureDetailHome
      self.fixtureDetailAway = fixtureDetailAway
    }
  }
  
  public enum Action {
    case fetchFixtureDetail
    case fixturesResponseHome(Result<FixtureDetail, Error>)
    case fixturesResponseAway(Result<FixtureDetail, Error>)
  }
  
  public init() {}
  
  @Dependency(\.fixtureClient) var fixtureClient
  @AppStorage(.useJSON) var isUseJSON

  private enum CancelID { case fixtureDetail }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .fetchFixtureDetail:
        return .run { [fixtureID = state.fixture.id, homeID = state.fixture.teams.home.id, awayID = state.fixture.teams.away.id] send in
          await send(.fixturesResponseHome(Result { try await self.fixtureClient.getFixtureDetail(homeID, fixtureID, true, isUseJSON) }))
          await send(.fixturesResponseAway(Result { try await self.fixtureClient.getFixtureDetail(awayID, fixtureID, false, isUseJSON) }))
        }
      case let .fixturesResponseHome(.success(response)):
        state.fixtureDetailHome = response
        return .none
      case .fixturesResponseHome(.failure):
        return .none
      case let .fixturesResponseAway(.success(response)):
        state.fixtureDetailAway = response
        return .none
      case .fixturesResponseAway(.failure):
        return .none
      }
    }
  }
}

public struct FixtureDetailView: View {
  @Bindable var store: StoreOf<FixtureDetailReducer>
  @Environment(\.dismiss) var dismiss
  
  public init(store: StoreOf<FixtureDetailReducer>) {
    self.store = store
  }
  
  public var body: some View {
    VStack(spacing: 16) {
      // ヘッダー
      HStack {
        Button(action: {
          dismiss()
        }, label: {
          Image(systemName: "chevron.left")
            .foregroundColor(Color.white)
        })
        Spacer()
      }
      .padding(EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 0))
      
      ScrollView {
        // スコア表示領域
        FixturesListCell(fixture: store.state.fixture)
          .padding(.horizontal, 24)
        
        Spacer().frame(height: 32)
        
        // 得点者
        
        // スタッツ表示領域(statsTypeのenumで表示分けれるようにしたい)
        if let homeFixtureDetail = store.state.fixtureDetailHome, let awayFixtureDetail = store.state.fixtureDetailAway {
          VStack(spacing: 48) {
            // 総シュート
            FixtureDetailStatsCell(
              statsType: .totalShots,
              homeValue: homeFixtureDetail.totalShots,
              awayValue: awayFixtureDetail.totalShots,
              home: store.state.fixture.teams.home,
              away: store.state.fixture.teams.away
            )
            // 枠内シュート
            FixtureDetailStatsCell(
              statsType: .shotsOnGoal,
              homeValue: homeFixtureDetail.shotsOnGoal,
              awayValue: awayFixtureDetail.shotsOnGoal,
              home: store.state.fixture.teams.home,
              away: store.state.fixture.teams.away
            )
            // ポゼッション
            FixtureDetailStatsCell(
              statsType: .ballPossession,
              homeValue: homeFixtureDetail.ballPossession,
              awayValue: awayFixtureDetail.ballPossession,
              home: store.state.fixture.teams.home,
              away: store.state.fixture.teams.away
            )
            // xG
            FixtureDetailStatsCell(
              statsType: .expectedGoals,
              homeValue: homeFixtureDetail.expectedGoals,
              awayValue: awayFixtureDetail.expectedGoals,
              home: store.state.fixture.teams.home,
              away: store.state.fixture.teams.away
            )
          }
        }
        
        // メンバー
        
        
        
        Spacer()
      }
    }
    .background(store.state.leagueType.themaColor)
    .task {
      do {
        try await Task.sleep(for: .milliseconds(300))
        await store.send(.fetchFixtureDetail).finish()
      } catch {}
    }
    .navigationBarBackButtonHidden()
  }
}
