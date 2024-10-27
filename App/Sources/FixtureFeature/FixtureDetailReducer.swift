//
//  FixtureDetailReducer.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/25.
//

import Foundation
import ComposableArchitecture

@Reducer
struct FixtureDetailReducer {
    @ObservableState
    struct State: Equatable {
        let leagueType: LeagueType
        let fixture: Fixture
        var fixtureDetailHome: FixtureDetail?
        var fixtureDetailAway: FixtureDetail?
    }

    enum Action {
        case fetchFixtureDetail
        case fixturesResponseHome(Result<FixtureDetail, Error>)
        case fixturesResponseAway(Result<FixtureDetail, Error>)
    }

    @Dependency(\.fixtureClient) var fixtureClient
    private enum CancelID { case fixtureDetail }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchFixtureDetail:
                return .run { [fixtureID = state.fixture.id, homeID = state.fixture.teams.home.id, awayID = state.fixture.teams.away.id] send in
                    await send(.fixturesResponseHome(Result { try await self.fixtureClient.getFixtureDetail(teamID: homeID, fixtureID: fixtureID, isHome: true) }))
                    await send(.fixturesResponseAway(Result { try await self.fixtureClient.getFixtureDetail(teamID: awayID, fixtureID: fixtureID, isHome: false) }))
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
