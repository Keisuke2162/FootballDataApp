//
//  StatsContainerView.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/23.
//

import ComposableArchitecture
import SwiftUI

struct StatsContainerView: View {
    @Bindable var store: StoreOf<StatsContainerReducer>

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(StatType.allCases, id: \.self) { type in
                        Button(action: {
                            store.send(.selectedType(type))
                        }, label: {
                            VStack {
                                Text(type.title)
                                    .foregroundColor(store.state.selectedStatsType == type ? Color.white : Color.gray)
                                    .font(.custom("SSportsD-Medium", size: 12))
                                Rectangle()
                                    .fill(store.state.selectedStatsType == type ? Color.white : Color.clear)
                                    .frame(height: 4)
                            }
                        })
                    }
                }
                TabView(selection: $store.selectedStatsType.sending(\.selectedType)) {
                    PlayerStatsView(store: self.store.scope(state: \.topScorerList, action: \.topScorerList))
                        .tag(StatType.topScorers)
                        .toolbarBackground(.hidden, for: .tabBar)
                    PlayerStatsView(store: self.store.scope(state: \.topAssistList, action: \.topAssistList))
                        .tag(StatType.topAssists)
                        .toolbarBackground(.hidden, for: .tabBar)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: store.state.selectedStatsType)
            }
            .background(store.state.leagueType.themaColor)
        }
    }
}

#Preview {
    StatsContainerView(store: Store(initialState: StatsContainerReducer.State(leagueType: .england), reducer: {
        StatsContainerReducer()
    }))
}
