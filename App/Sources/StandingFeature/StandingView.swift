//
//  StandingView.swift
//  FootballDataManager
//
//  Created by Kei on 2023/10/02.
//

import ComposableArchitecture
import SwiftUI

struct StandingView: View {
    @Bindable var store: StoreOf<StandingReducer>

    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 8) {
                    Spacer().frame(width: 16)
                    Text("Pos")
                        .font(.custom("SSportsD-Medium", size: 12))
                        .frame(width: 24)
                    Text("Club")
                        .font(.custom("SSportsD-Medium", size: 12))
                        .frame(width: 32)
                        .padding(.leading, 46)
                    Spacer()
                    Text("P")
                        .font(.custom("SSportsD-Medium", size: 12))
                        .frame(width: 24)
                    Text("GD")
                        .font(.custom("SSportsD-Medium", size: 12))
                        .frame(width: 24)
                    Text("Pts")
                        .font(.custom("SSportsD-Medium", size: 12))
                        .frame(width: 24)
                    Spacer().frame(width: 16)
                }
                .frame(height: 32)
                List {
                    ForEach(store.standings) { standing in
                        StandingCellView(standingItem: standing)
                            .frame(height: 46)
                            .listRowBackground(Color.clear)
                    }
                    Spacer().frame(height: 50).listRowBackground(EmptyView())
                }
                .scrollContentBackground(.hidden)
                .background(store.state.leagueType.themaColor)
                .listStyle(.grouped)
            }
            
        }
        .task {
            do {
                try await Task.sleep(for: .milliseconds(300))
                await store.send(.fetchStandings).finish()
            } catch {}
        }
    }
}

#Preview {
    StandingView(store: Store(initialState: StandingReducer.State(leagueType: .spain), reducer: {
        StandingReducer()
    }))
}
