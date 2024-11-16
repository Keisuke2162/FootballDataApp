//
//  DisplayTab.swift
//  App
//
//  Created by Kei on 2024/11/16.
//

public enum DisplayTab: String, CaseIterable, Equatable {
  case table
  case fixtures
  case playerStats

  public var systemIconName: String {
    switch self {
    case .table:
      "list.bullet.rectangle.fill"
    case .fixtures:
      "sportscourt.fill"
    case .playerStats:
      "figure.soccer"
    }
  }
}
