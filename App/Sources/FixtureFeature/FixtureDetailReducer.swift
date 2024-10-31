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
    ZStack {
      VStack(spacing: 16) {
        // スコア表示領域
        HStack {
          Spacer()
          KFImage(URL(string: store.state.fixture.teams.home.logo))
            .resizable()
            .scaledToFit()
            .frame(width: 56, height: 56)
          Spacer()
          Text(store.state.fixture.goals.home?.description ?? "")
            .foregroundColor(Color.white)
            .font(.custom("SSportsD-Medium", size: 24))
          Text("-")
            .foregroundColor(Color.white)
            .font(.custom("SSportsD-Medium", size: 24))
          Text(store.state.fixture.goals.away?.description ?? "")
            .foregroundColor(Color.white)
            .font(.custom("SSportsD-Medium", size: 24))
          Spacer()
          KFImage(URL(string: store.state.fixture.teams.away.logo))
            .resizable()
            .scaledToFit()
            .frame(width: 56, height: 56)
          Spacer()
        }
        .frame(height: 160)
        .background(store.state.leagueType.themaColor)
        // 得点者
        
        // スタッツ表示領域
        if let homeFixtureDetail = store.state.fixtureDetailHome, let awayFixtureDetail = store.state.fixtureDetailAway {
          VStack(spacing: 24) {
            // 総シュート
            FixtureDetailStatsCell(statsType: .totalShots,
                                   homeValue: homeFixtureDetail.totalShots,
                                   awayValue: awayFixtureDetail.totalShots)
            // 枠内シュート
            FixtureDetailStatsCell(statsType: .shotsOnGoal,
                                   homeValue: homeFixtureDetail.shotsOnGoal,
                                   awayValue: awayFixtureDetail.shotsOnGoal)
            // ポゼッション
            FixtureDetailStatsCell(statsType: .ballPossession,
                                   homeValue: homeFixtureDetail.ballPossession,
                                   awayValue: awayFixtureDetail.ballPossession)
            // xG
            FixtureDetailStatsCell(statsType: .expectedGoals,
                                   homeValue: homeFixtureDetail.expectedGoals,
                                   awayValue: awayFixtureDetail.expectedGoals)
          }
        }
        
        // メンバー
        
        
        
        Spacer()
      }
      VStack {
        HStack {
          Button(action: {
            dismiss()
          }, label: {
            Text("←")
              .foregroundColor(Color.black)
              .padding(EdgeInsets(top: 4, leading: 8, bottom: 8, trailing: 8))
              .font(.custom("SSportsD-Medium", size: 24))
              .frame(width: 40, height: 40)
              .background(Color.white)
              .clipShape(RoundedRectangle(cornerRadius: 10))
          })
          Spacer()
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
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
