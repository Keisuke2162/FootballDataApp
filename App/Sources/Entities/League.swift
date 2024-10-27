//
//  League.swift
//  FootballDataManager
//
//  Created by Kei on 2023/10/01.
//

import Foundation

struct League: Hashable {
    let leagueID: String
    let name: String
    let imageString: String
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.leagueID == rhs.leagueID
    }
        
    func hash(into hasher: inout Hasher) {
        hasher.combine(leagueID)
    }
}
