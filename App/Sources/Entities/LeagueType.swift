//
//  LeagueType.swift
//  FootballDataManager
//
//  Created by Kei on 2024/02/18.
//

import Foundation
import SwiftUI

enum LeagueType: CaseIterable, Identifiable, Equatable {
    case england
    case italy
    case spain
    case japan
}

extension LeagueType {
    var id: String {
        switch self {
        case .england:
            "39"
        case .italy:
            "135"
        case .spain:
            "140"
        case .japan:
            "98"
        }
    }

    var name: String {
        switch self {
        case .england:
            "Premier League"
        case .italy:
            "Serie A"
        case .spain:
            "La Liga"
        case .japan:
            "J League"
        }
    }

    var themaColor: Color {
        switch self {
        case .england:
            Color.init("background-premier")
        case .italy:
            Color.init("background-seriea")
        case .spain:
            Color.init("background-laliga")
        case .japan:
            Color.init("background-japan")
        }
    }

    var standingResource: String {
        switch self {
        case .england:
            "football_api_standings_2023_39"
        case .italy:
            "football_api_standings_2023_135"
        case .spain:
            "football_api_standings_2023_140"
        case .japan:
            "football_api_standings_2024_98"
        }
    }

    var fixturesResource: String {
        switch self {
        case .england:
            "foorball_api_fixtures_2023_39"
        case .italy:
            "foorball_api_fixtures_2023_135"
        case .spain:
            "foorball_api_fixtures_2023_140"
        case .japan:
            "foorball_api_fixtures_2024_98"
        }
    }

    var topScorerResource: String {
        switch self {
        case .england:
            "foorball_api_topscorer_2023_39"
        case .italy:
            "foorball_api_topscorer_2023_135"
        case .spain:
            "foorball_api_topscorer_2023_140"
        case .japan:
            "foorball_api_topscorer_2024_98"
        }
    }

    var topAssistResource: String {
        switch self {
        case .england:
            "foorball_api_topassists_2023_39"
        case .italy:
            "foorball_api_topassists_2023_135"
        case .spain:
            "foorball_api_topassists_2023_140"
        case .japan:
            "foorball_api_topassists_2024_98"
        }
    }

    var iconImage: Image {
        switch self {
        case .england:
            Image("ic-england")
        case .italy:
            Image("ic-italy")
        case .spain:
            Image("ic-spain")
        case .japan:
            Image("ic-japan")
        }
    }
}
