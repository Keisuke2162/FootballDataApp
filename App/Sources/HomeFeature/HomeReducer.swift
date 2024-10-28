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

@Reducer
public struct HomeReducer {
  @ObservableState
  public struct State: Equatable {
    @Presents var destination: Destination.State?
    public var selectedLeagueType: LeagueType = .england
    public var standingList = StandingReducer.State(leagueType: .england)
    public var fixtureSchedule = FixturesReducer.State(leagueType: .england)
    public var statsList = StatsContainerReducer.State(leagueType: .england)
    
    public init() {
    }
  }
  
  public enum Action {
    case tapSelectLeagueButton
    case destination(PresentationAction<Destination.Action>)
    case standingList(StandingReducer.Action)
    case fixtureSchedule(FixturesReducer.Action)
    case statsList(StatsContainerReducer.Action)
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
  
  public init(store: StoreOf<HomeReducer>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationView {
      ZStack {
        TabView {
          StandingView(store: store.scope(state: \.standingList, action: \.standingList))
            .tabItem {
              Image(systemName: "list.bullet.rectangle.fill")
              Text("Table")
            }
            .toolbarBackground(.white, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
          FixturesView(store: store.scope(state: \.fixtureSchedule, action: \.fixtureSchedule))
            .tabItem {
              Image(systemName: "sportscourt.fill")
              Text("Fixture")
            }
            .toolbarBackground(.white, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
          StatsContainerView(store: store.scope(state: \.statsList, action: \.statsList))
            .tabItem {
              Image(systemName: "figure.soccer")
              Text("Stats")
            }
            .toolbarBackground(.white, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
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
          
          Spacer().frame(height: 50).listRowBackground(EmptyView())
        }
      }
    }
    .sheet(item: $store.scope(state: \.destination?.changeLeague, action: \.destination.changeLeague)) { changeLeagueStore in
      SelectLeagueView(store: changeLeagueStore)
    }
  }
}
