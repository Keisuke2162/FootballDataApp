//
//  FixtureDetailStatsCell.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/26.
//

import SwiftUI
import Entities

public struct FixtureDetailStatsCell: View {
  public let statsType: StatisticType
  public let homeValue: String
  public let awayValue: String

  public init(statsType: StatisticType, homeValue: String, awayValue: String) {
    self.statsType = statsType
    self.homeValue = homeValue
    self.awayValue = awayValue
  }
  
  public var body: some View {
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
