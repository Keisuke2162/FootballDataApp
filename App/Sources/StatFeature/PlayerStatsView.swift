//
//  StatsView.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/21.
//

import ComposableArchitecture
import SwiftUI

struct PlayerStatsView: View {
    @Bindable var store: StoreOf<PlayerStatsReducer>

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.topScorerStats) { scorer in
                    PlayerStatsListCell(statType: store.state.statType, playerStatsItem: scorer)
                        .frame(height: 46)
                        .listRowBackground(Color.clear)
                }
                Spacer().frame(height: 50).listRowBackground(EmptyView())
            }
            .scrollContentBackground(.hidden)
            .background(store.state.leagueType.themaColor)
            .listStyle(.grouped)
        }
        .task {
            do {
                try await Task.sleep(for: .milliseconds(300))
                await store.send(.fetchTopScorer).finish()
            } catch {}
        }
    }
}

#Preview {
    PlayerStatsView(store: Store(initialState: PlayerStatsReducer.State(leagueType: .england, statType: .topScorers), reducer: {
        PlayerStatsReducer()
    }))
}
