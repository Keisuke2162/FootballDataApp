//
//  ScheduleReducer.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/18.
//

import Foundation
import ComposableArchitecture

@Reducer
struct FixturesReducer {
//    @Reducer(state: .equatable)
//    enum Path {
//        case detail(FixtureDetailReducer)
//    }

    @ObservableState
    struct State: Equatable {
        let leagueType: LeagueType
        var fixtures: [Fixture] = []
        var selectedDateIndex: Int = 0
        var groupedItems: [String: [Fixture]] = [:]
        var dateKeys: [String] = []
        var path = StackState<FixtureDetailReducer.State>()
    }

    enum Action {
        case fetchFixtures
        case fixturesResponse(Result<FixturesItem, Error>)
        case backDateButton
        case forwardDateButton
        case path(StackAction<FixtureDetailReducer.State, FixtureDetailReducer.Action>)
    }

    @Dependency(\.fixtureClient) var fixtureClient
    private enum CancelID { case fixtures }

    var body: some Reducer<State, Action> {
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
