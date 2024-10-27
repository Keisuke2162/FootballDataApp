//
//  StandingCellView.swift
//  FootballDataManager
//
//  Created by Kei on 2023/10/11.
//

import Kingfisher
import SwiftUI

struct StandingCellView: View {
    let standingItem: Standing

    var body: some View {
        HStack(spacing: 16.0) {
            Text(standingItem.rank.description)
                .foregroundColor(Color.white)
                .font(.custom("SSportsD-Medium", size: 12))
                .frame(width: 24)
            let imageURL = URL(string: standingItem.team.logo)
            KFImage(imageURL)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
            Text(standingItem.team.name)
                .foregroundColor(Color.white)
                .font(.custom("SSportsD-Medium", size: 16))
            Spacer()
            Text(standingItem.all.played.description)
                .foregroundColor(Color.white)
                .font(.custom("SSportsD-Medium", size: 16))
                .frame(width: 24)
            Text(standingItem.goalsDiff.description)
                .foregroundColor(Color.white)
                .font(.custom("SSportsD-Medium", size: 16))
                .frame(width: 24)
            Text(standingItem.points.description)
                .foregroundColor(Color.white)
                .font(.custom("SSportsD-Medium", size: 16))
                .frame(width: 24)
        }
    }
}
