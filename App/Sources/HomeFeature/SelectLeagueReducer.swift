//
//  SelectLeagueReducer.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/18.
//

import Entities
import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
public struct SelectLeagueReducer : Sendable{
  @ObservableState
  public struct State: Equatable {
    public var selectedLeagueType: LeagueType
    
    public init(selectedLeagueType: LeagueType) {
      self.selectedLeagueType = selectedLeagueType
    }
  }
  
  public enum Action {
    case tapLeagueCell(LeagueType)
    case delegate(Delegate)
    
    @CasePathable
    public enum Delegate: Equatable {
      case selectLeague(LeagueType)
    }
  }
  
  @Dependency(\.dismiss) var dismiss
  
  public init() {
  }
  
  public var body: some Reducer<State, Action> {
    Reduce { state, action in
      switch action {
        // ボタンタップ時に選択モーダル表示
      case let .tapLeagueCell(leagueType):
        return .run { send in
          await send(.delegate(.selectLeague(leagueType)))
          await self.dismiss()
        }
      case .delegate:
        return .none
      }
    }
  }
}

public struct SelectLeagueView: View {
  @Bindable var store: StoreOf<SelectLeagueReducer>
  
  public var body: some View {
    List {
      ForEach(LeagueType.allCases) { type in
        Button {
          store.send(.tapLeagueCell(type))
        } label: {
          HStack(spacing: 16) {
            type.iconImage
              .resizable()
              .frame(width: 40, height: 40)
            Text(type.name)
          }
        }
      }
    }
  }
}
