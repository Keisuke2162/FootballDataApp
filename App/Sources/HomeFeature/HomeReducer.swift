//
//  HomeReducer.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/18.
//

import Foundation
import ComposableArchitecture
import Entities
import SwiftUI
import StandingFeature
import FixtureFeature
import StatFeature
import Utilities

@Reducer
public struct HomeReducer {
  @ObservableState
  public struct State: Equatable {
    public var currentTab: DisplayTab = .table
    @Presents var destination: Destination.State?
    public var selectedLeagueType: LeagueType = .japan
    public var standingList = StandingReducer.State(leagueType: .japan)
    public var fixtureSchedule = FixturesReducer.State(leagueType: .japan)
    public var statsList = StatsContainerReducer.State(leagueType: .japan)
    
    public init() {
    }
  }
  
  public enum Action {
    case tapSelectLeagueButton
    case destination(PresentationAction<Destination.Action>)
    case standingList(StandingReducer.Action)
    case fixtureSchedule(FixturesReducer.Action)
    case statsList(StatsContainerReducer.Action)
    case selectTab(DisplayTab)
  }
  
  public init() {
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.standingList, action: \.standingList) {
      StandingReducer()
    }
    Scope(state: \.fixtureSchedule, action: \.fixtureSchedule) {
      FixturesReducer()
    }
    Scope(state: \.statsList, action: \.statsList) {
      StatsContainerReducer()
    }
    Reduce { state, action in
      switch action {
      case .tapSelectLeagueButton:
        state.destination = .changeLeague(SelectLeagueReducer.State(selectedLeagueType: state.selectedLeagueType))
        return .none
      case let .destination(.presented(.changeLeague(.delegate(.selectLeague(type))))):
        state.selectedLeagueType = type
        state.standingList = .init(leagueType: type)
        state.fixtureSchedule = .init(leagueType: type)
        state.statsList = .init(leagueType: type)
        return .run { send in
          await send(.standingList(.fetchStandings))
          await send(.fixtureSchedule(.fetchFixtures))
          await send(.statsList(.updateLeagueType))
        }
      case .destination:
        return .none
      case .standingList:
        return .none
      case .fixtureSchedule:
        return .none
      case .statsList:
        return .none
      case let .selectTab(tab):
        state.currentTab = tab
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }
}

extension HomeReducer {
  @Reducer(state: .equatable)
  public enum Destination {
    case changeLeague(SelectLeagueReducer)
    case fixtureSchedule(FixturesReducer)
  }
}

@MainActor
public struct HomeView: View {
  @Bindable var store: StoreOf<HomeReducer>
  @AppStorage(.useJSON) var isUseJSON

  public init(store: StoreOf<HomeReducer>) {
    self.store = store
    UITabBar.appearance().isHidden = true
  }
  
  public var body: some View {
    NavigationView {
      ZStack {
        VStack(spacing: .zero) {
          TabView(selection: $store.currentTab.sending(\.selectTab)) {
            StandingView(store: store.scope(state: \.standingList, action: \.standingList))
              .tag(DisplayTab.table)
            FixturesView(store: store.scope(state: \.fixtureSchedule, action: \.fixtureSchedule))
              .tag(DisplayTab.fixtures)
            StatsContainerView(store: store.scope(state: \.statsList, action: \.statsList))
              .tag(DisplayTab.playerStats)
          }
        }
        .ignoresSafeArea(.all)
        
        VStack {
          Spacer()
          HStack {
            Spacer()
            Button {
              store.send(.tapSelectLeagueButton)
            } label: {
              store.state.selectedLeagueType.iconImage
                .resizable()
                .frame(width: 40, height: 40)
                .padding()
            }
            .background(Color.white)
            .cornerRadius(40)
            .padding(20)
          }
          
          CustomTabBar(currentTab: $store.currentTab.sending(\.selectTab), colorStr: "111111")
          
          Spacer().frame(height: 32).listRowBackground(EmptyView())
        }
      }
    }
    .sheet(item: $store.scope(state: \.destination?.changeLeague, action: \.destination.changeLeague)) { changeLeagueStore in
      SelectLeagueView(store: changeLeagueStore)
    }
  }
}
