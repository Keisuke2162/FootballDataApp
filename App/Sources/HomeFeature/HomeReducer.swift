//
//  HomeReducer.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/18.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HomeReducer {
    @ObservableState
    struct State: Equatable {
        @Presents var destination: Destination.State?
        var selectedLeagueType: LeagueType = .england
        var standingList = StandingReducer.State(leagueType: .england)
        var fixtureSchedule = FixturesReducer.State(leagueType: .england)
        var statsList = StatsContainerReducer.State(leagueType: .england)
    }

    enum Action {
        case tapSelectLeagueButton
        case destination(PresentationAction<Destination.Action>)
        case standingList(StandingReducer.Action)
        case fixtureSchedule(FixturesReducer.Action)
        case statsList(StatsContainerReducer.Action)
    }

    var body: some ReducerOf<Self> {
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
    enum Destination {
        case changeLeague(SelectLeagueReducer)
        case fixtureSchedule(FixturesReducer)
    }
}
