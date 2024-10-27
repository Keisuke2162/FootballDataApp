//
//  FixtureDetailStatsCell.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/26.
//

import SwiftUI

struct FixtureDetailStatsCell: View {
    let statsType: StatisticType
    let homeValue: String
    let awayValue: String

    var body: some View {
        HStack {
            Spacer()
            Text(homeValue)
                .foregroundColor(Color.white)
                .font(.custom("SSportsD-Medium", size: 20))
            Spacer()
            Text(statsType.rawValue)
                .foregroundColor(Color.white)
                .font(.custom("SSportsD-Medium", size: 12))
            Spacer()
            Text(awayValue)
                .foregroundColor(Color.white)
                .font(.custom("SSportsD-Medium", size: 20))
            Spacer()
        }
    }
}
