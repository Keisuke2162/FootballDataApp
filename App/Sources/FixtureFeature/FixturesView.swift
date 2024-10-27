//
//  FixturesView.swift
//  FootballDataManager
//
//  Created by Kei on 2023/10/09.
//

import ComposableArchitecture
import Kingfisher
import SwiftUI

struct FixturesView: View {
    @Bindable var store: StoreOf<FixturesReducer>
 
    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            VStack {
                if store.state.fixtures.isEmpty {
                    Color.clear
                } else {
                    HStack {
                        Spacer()
                        Button {
                            store.send(.backDateButton)
                        } label: {
                            Text("←")
                                .foregroundColor(Color.init("SkySportsBlue"))
                                .font(.custom("SSportsD-Medium", size: 16))
                        }
                        Spacer()
                        Text(store.state.dateKeys.isEmpty ? "" : store.state.dateKeys[store.selectedDateIndex])
                            .foregroundColor(Color.init("SkySportsBlue"))
                            .font(.custom("SSportsD-Medium", size: 16))
                        Spacer()
                        Button {
                            store.send(.forwardDateButton)
                        } label: {
                            Text("→")
                                .foregroundColor(store.state.leagueType.themaColor)
                                .font(.custom("SSportsD-Medium", size: 16))
                        }
                        Spacer()
                    }
                    .frame(height: 32)
                    .background(Color.white)
                    List {
                        ForEach(store.groupedItems[store.dateKeys[store.selectedDateIndex]] ?? []) { item in
                            NavigationLink(state: FixtureDetailReducer.State(leagueType: store.state.leagueType, fixture: item)) {
                                HStack {
                                    Spacer()
                                    KFImage(URL(string: item.teams.home.logo))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                    Spacer()
                                    Text(item.goals.home?.description ?? "")
                                        .foregroundColor(Color.white)
                                        .font(.custom("SSportsD-Medium", size: 16))
                                    Text("-")
                                        .foregroundColor(Color.white)
                                        .font(.custom("SSportsD-Medium", size: 16))
                                    Text(item.goals.away?.description ?? "")
                                        .foregroundColor(Color.white)
                                        .font(.custom("SSportsD-Medium", size: 16))
                                    Spacer()
                                    KFImage(URL(string: item.teams.away.logo))
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                    Spacer()
                                }
                            }
                            .frame(height: 56)
                            .listRowBackground(Color.clear)
                        }
                        Spacer().frame(height: 50).listRowBackground(EmptyView())
                    }
                    .scrollContentBackground(.hidden)
                    .background(store.state.leagueType.themaColor)
                    .listStyle(.grouped)
                }
            }
        } destination: { store in
            FixtureDetailView(store: store)
//            switch store.case {
//            case let .detail(store):
//                FixtureDetailView(store: store)
//            }
        }
        .task {
            do {
                try await Task.sleep(for: .milliseconds(300))
                await store.send(.fetchFixtures).finish()
            } catch {}
        }
    }
}

#Preview {
    FixturesView(store: Store(initialState: FixturesReducer.State(leagueType: .spain), reducer: {
        FixturesReducer()
    }))
}
