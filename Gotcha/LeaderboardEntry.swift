//
//  LeaderboardEntry.swift
//  Gotcha
//
//  Created on 9/19/26.
//

import Foundation


struct LeaderboardEntry: Identifiable {
    let id = UUID()
    let name: String
    let tagCount: Int
}
