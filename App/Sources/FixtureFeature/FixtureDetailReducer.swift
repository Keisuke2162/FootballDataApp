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
  private enum CancelID { case fixtureDetail }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .fetchFixtureDetail:
        //await send(.fixturesResponseHome(Result { try await self.fixtureClient.getFixtureDetail(teamID: homeID, fixtureID: fixtureID, isHome: true) }))
        return .run { [fixtureID = state.fixture.id, homeID = state.fixture.teams.home.id, awayID = state.fixture.teams.away.id] send in
          await send(.fixturesResponseHome(Result { try await self.fixtureClient.getFixtureDetail(homeID, fixtureID, true) }))
          await send(.fixturesResponseAway(Result { try await self.fixtureClient.getFixtureDetail(awayID, fixtureID, false) }))
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
          VStack(spacing: 32) {
            // 総シュート
            FixtureDetailStatsCell(
              statsType: .totalShots,
              homeValue: homeFixtureDetail.totalShots,
              awayValue: awayFixtureDetail.totalShots,
              home: homeFixtureDetail.team,
              away: awayFixtureDetail.team
            )
            // 枠内シュート
            FixtureDetailStatsCell(
              statsType: .shotsOnGoal,
              homeValue: homeFixtureDetail.shotsOnGoal,
              awayValue: awayFixtureDetail.shotsOnGoal,
              home: homeFixtureDetail.team,
              away: awayFixtureDetail.team
            )
            // ポゼッション
            FixtureDetailStatsCell(
              statsType: .ballPossession,
              homeValue: homeFixtureDetail.ballPossession,
              awayValue: awayFixtureDetail.ballPossession,
              home: homeFixtureDetail.team,
              away: awayFixtureDetail.team
            )
            // xG
            FixtureDetailStatsCell(
              statsType: .expectedGoals,
              homeValue: homeFixtureDetail.expectedGoals,
              awayValue: awayFixtureDetail.expectedGoals,
              home: homeFixtureDetail.team,
              away: awayFixtureDetail.team
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
