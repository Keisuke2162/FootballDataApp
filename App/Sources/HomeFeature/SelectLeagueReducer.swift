//
//  SelectLeagueReducer.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/18.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SelectLeagueReducer {
    @ObservableState
    struct State: Equatable {
        var selectedLeagueType: LeagueType

        public init(selectedLeagueType: LeagueType) {
            self.selectedLeagueType = selectedLeagueType
        }
    }

    enum Action {
        case tapLeagueCell(LeagueType)
        case delegate(Delegate)

        @CasePathable
        enum Delegate: Equatable {
            case selectLeague(LeagueType)
        }
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
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
