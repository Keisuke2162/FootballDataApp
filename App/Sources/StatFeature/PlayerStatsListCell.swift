//
//  PlayerStatsCellView.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/23.
//

import Kingfisher
import SwiftUI
import Entities

public struct PlayerStatsListCell: View {
  public let statType: StatType
  public let playerStatsItem: PlayerStats
  
  public init(statType: StatType, playerStatsItem: PlayerStats) {
    self.statType = statType
    self.playerStatsItem = playerStatsItem
  }
  
  public var body: some View {
    HStack(spacing: 16.0) {
      let imageURL = URL(string: playerStatsItem.statistics[0].team.logo)
      KFImage(imageURL)
        .resizable()
        .scaledToFit()
        .frame(width: 30, height: 30)
      Text(playerStatsItem.player.name)
        .foregroundColor(Color.white)
        .font(.custom("SSportsD-Medium", size: 12))
      Spacer()
      switch statType {
      case .topScorers:
        Text("\(playerStatsItem.statistics[0].goals.total ?? 0)")
          .foregroundColor(Color.white)
          .font(.custom("SSportsD-Medium", size: 16))
      case .topAssists:
        Text("\(playerStatsItem.statistics[0].goals.assists ?? 0)")
          .foregroundColor(Color.white)
          .font(.custom("SSportsD-Medium", size: 16))
      }
    }
  }
}
