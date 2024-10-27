//
//  StatsContainerReducer.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/23.
//

import ComposableArchitecture
import Foundation

@Reducer
struct StatsContainerReducer {
    @ObservableState
    struct State: Equatable {
        let leagueType: LeagueType
        var selectedStatsType: StatType = .topScorers
        var topScorerList = PlayerStatsReducer.State(leagueType: .england, statType: .topScorers)
        var topAssistList = PlayerStatsReducer.State(leagueType: .england, statType: .topAssists)
    }

    enum Action {
        case selectedType(StatType)
        case updateLeagueType
        case topScorerList(PlayerStatsReducer.Action)
        case topAssistList(PlayerStatsReducer.Action)
    }

    var body: some ReducerOf<Self> {
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
