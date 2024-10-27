//
//  SelectLeagueView.swift
//  FootballDataManager
//
//  Created by Kei on 2023/10/06.
//

import ComposableArchitecture
import SwiftUI

struct SelectLeagueView: View {
    @Bindable var store: StoreOf<SelectLeagueReducer>

    var body: some View {
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

#Preview {
    SelectLeagueView(store: .init(initialState: SelectLeagueReducer.State(selectedLeagueType: .england), reducer: {
        SelectLeagueReducer()
    }))
}
