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
  public let order: Int

  public var imageWidth: CGFloat {
    switch order {
    case 0:
      64
    case 1:
      56
    case 2:
      48
    default:
      40
    }
  }
  
  public init(statType: StatType, playerStatsItem: PlayerStats, order: Int) {
    self.statType = statType
    self.playerStatsItem = playerStatsItem
    self.order = order
  }
  
  public var body: some View {
    HStack(spacing: 16.0) {
      let imageURL = URL(string: playerStatsItem.statistics[0].team.logo)
      KFImage(imageURL)
        .resizable()
        .scaledToFit()
        .frame(width: imageWidth, height: imageWidth)
        .padding(.vertical, 8)
      Text(playerStatsItem.player.name)
        .foregroundColor(Color.white)
        .font(.custom("SSportsD-Medium", size: 24))
      Spacer()
      switch statType {
      case .topScorers:
        Text("\(playerStatsItem.statistics[0].goals.total ?? 0)")
          .foregroundColor(Color.white)
          .font(.custom("SSportsD-Medium", size: 24))
      case .topAssists:
        Text("\(playerStatsItem.statistics[0].goals.assists ?? 0)")
          .foregroundColor(Color.white)
          .font(.custom("SSportsD-Medium", size: 24))
      }
    }
    .padding(.horizontal, 16)
    .background {
      Color(hexValue: playerStatsItem.statistics[0].team.theme.mainColorCode).opacity(0.4)
    }
    .clipShape(.rect(cornerRadius: 8))
  }
}
