//
//  ScheduleReducer.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/18.
//

import Foundation
import ComposableArchitecture
import Entities
import Kingfisher
import SwiftUI

@Reducer
public struct FixturesReducer : Sendable{
  @ObservableState
  public struct State: Equatable {
    let leagueType: LeagueType
    var fixtures: [Fixture] = []
    var selectedDateIndex: Int = 0
    var groupedItems: [String: [Fixture]] = [:]
    var dateKeys: [String] = []
    var path = StackState<FixtureDetailReducer.State>()
    
    public init(leagueType: LeagueType) {
      self.leagueType = leagueType
    }
  }
  
  public enum Action {
    case fetchFixtures
    case fixturesResponse(Result<FixturesItem, Error>)
    case backDateButton
    case forwardDateButton
    case path(StackAction<FixtureDetailReducer.State, FixtureDetailReducer.Action>)
  }
  
  public init() {
  }
  
  @Dependency(\.fixtureClient) var fixtureClient
  private enum CancelID { case fixtures }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
      case .fetchFixtures:
        return .run { [leagueType = state.leagueType] send in
          await send(.fixturesResponse(Result { try await self.fixtureClient.getFixtures(leagueType) }))
        }
        .cancellable(id: CancelID.fixtures)
      case .fixturesResponse(.failure):
        return .none
      case let .fixturesResponse(.success(response)):
        state.fixtures = response.response
        state.groupedItems = response.groupedItems
        state.dateKeys = response.dateKeys
        return .none
      case .backDateButton:
        if state.selectedDateIndex > 0 {
          state.selectedDateIndex -= 1
        }
        return .none
      case .forwardDateButton:
        if state.selectedDateIndex < state.dateKeys.count - 1 {
          state.selectedDateIndex += 1
        }
        return .none
      case .path:
        return .none
      }
    }
    .forEach(\.path, action: \.path) {
      FixtureDetailReducer()
    }
  }
}

public struct FixturesView: View {
  @Bindable var store: StoreOf<FixturesReducer>
  
  public init(store: StoreOf<FixturesReducer>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      VStack(spacing: .zero) {
        if store.state.fixtures.isEmpty {
          Color.clear
        } else {
          // MEMO: header部分component化しても良さそう
          HStack {
            Spacer()
            Button {
              store.send(.backDateButton)
            } label: {
              Image(systemName: "chevron.left")
                .foregroundColor(Color.white)
            }
            Spacer()
            Text(store.state.dateKeys.isEmpty ? "" : store.state.dateKeys[store.selectedDateIndex])
              .foregroundColor(Color.white)
              .font(.headline)
              .padding(.vertical, 16)
            Spacer()
            Button {
              store.send(.forwardDateButton)
            } label: {
              Image(systemName: "chevron.right")
                .foregroundColor(Color.white)
            }
            Spacer()
          }
          .background(store.state.leagueType.themaColor)
          
          ScrollView {
            VStack(spacing: 16) {
              Spacer().frame(height: 16)
              ForEach(store.groupedItems[store.dateKeys[store.selectedDateIndex]] ?? []) { item in
                NavigationLink(state: FixtureDetailReducer.State(leagueType: store.state.leagueType, fixture: item)) {
                  FixturesListCell(fixture: item)
                }
                .padding(.horizontal, 24)
              }
              Spacer().frame(height: 120)
            }
          }
        }
      }
      .background(store.state.leagueType.themaColor)
    } destination: { store in
      FixtureDetailView(store: store)
    }
    .task {
      do {
        try await Task.sleep(for: .milliseconds(300))
        await store.send(.fetchFixtures).finish()
      } catch {}
    }
  }
}
struct HideDisclosureIndicator: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(PlainButtonStyle())
            .padding(.trailing, 8)
    }
}

extension View {
    func hideDisclosureIndicator() -> some View {
        modifier(HideDisclosureIndicator())
    }
}
