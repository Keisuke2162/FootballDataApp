//
//  FixturesListCell.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/28.
//

import ComposableArchitecture
import Kingfisher
import SwiftUI

struct FixturesListCell: View {
    let fixture: Fixture

    var body: some View {
        HStack {
            Spacer()
            KFImage(URL(string: fixture.teams.home.logo))
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            Spacer()
            Text(fixture.goals.home?.description ?? "")
                .foregroundColor(Color.white)
                .font(.custom("SSportsD-Medium", size: 16))
            Text("-")
                .foregroundColor(Color.white)
                .font(.custom("SSportsD-Medium", size: 16))
            Text(fixture.goals.away?.description ?? "")
                .foregroundColor(Color.white)
                .font(.custom("SSportsD-Medium", size: 16))
            Spacer()
            KFImage(URL(string: fixture.teams.away.logo))
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
            Spacer()
        }
        .frame(height: 56)
        .listRowBackground(Color.clear)
    }
}
