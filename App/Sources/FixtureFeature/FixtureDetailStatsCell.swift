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
  public let home: FixtureTeam
  public let away: FixtureTeam
  
  public var homeIntValue: CGFloat {
    CGFloat(Int(homeValue.extractNumericPart()) ?? 0)
    
  }
  public var awayIntValue: CGFloat {
    CGFloat(Int(awayValue.extractNumericPart()) ?? 0)
  }
  public var totalIntValue: CGFloat {
    homeIntValue + awayIntValue
  }

  public init(
    statsType: StatisticType,
    homeValue: String,
    awayValue: String,
    home: FixtureTeam,
    away: FixtureTeam
  ) {
    self.statsType = statsType
    self.homeValue = homeValue
    self.awayValue = awayValue
    self.home = home
    self.away = away
  }
  
  public var body: some View {
    VStack {
      HStack {
        Spacer()
        Text(homeValue)
          .foregroundColor(Color.white)
          .font(.custom("SSportsD-Medium", size: 24))
        Spacer()
        Text(statsType.rawValue)
          .foregroundColor(Color.white)
          .font(.custom("SSportsD-Medium", size: 16))
        Spacer()
        Text(awayValue)
          .foregroundColor(Color.white)
          .font(.custom("SSportsD-Medium", size: 24))
        Spacer()
      }

      GeometryReader { geometry in
        HStack(spacing: .zero) {
          let homeWidth = totalIntValue > 0 ? geometry.size.width * (CGFloat(homeIntValue) / CGFloat(totalIntValue)) : 0
          let awayWidth = totalIntValue > 0 ? geometry.size.width * (CGFloat(awayIntValue) / CGFloat(totalIntValue)) : 0
          Color(hexValue: home.theme.mainColorCode)
            .frame(width: homeWidth)
          Color(hexValue: away.theme.mainColorCode)
            .frame(width: awayWidth)
        }
        .clipShape(.rect(cornerRadius: 4))
        .frame(height: 8)
      }
      .padding(.horizontal, 32)
    }
  }
}
