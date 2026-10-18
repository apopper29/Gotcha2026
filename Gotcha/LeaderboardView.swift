//
//  LeaderboardView.swift
//  Gotcha
//
//  Created on 9/9/26.
//

import SwiftUI

struct LeaderboardView: View {
    let leaderboardEntries = [
        LeaderboardEntry(name: "Bob", tagCount: 7),
        LeaderboardEntry(name: "Fred", tagCount: 3),
        LeaderboardEntry(name: "Jenny", tagCount: 5),
        LeaderboardEntry(name: "Thomas", tagCount: 2),
        LeaderboardEntry(name: "Ann", tagCount: 1)
        ]
    
    var sortedEntries: [LeaderboardEntry] {
        leaderboardEntries.sorted { $0.tagCount > $1.tagCount }
        }
    
    var body: some View {
        Text("Leaderboard")
            .font(.title)
            .fontWeight(.bold)
            .fontWidth(.expanded)
        Spacer()
        VStack {
            ForEach(Array(sortedEntries.enumerated()), id: \.element.id) { index, item in
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.secondary.opacity(0.2))
                        .frame(height: 80)
                    HStack {
                        let rankColor: Color = {
                            switch index {
                            case 0: return .yellow
                            case 1: return .gray
                            case 2: return .orange
                            default: return .secondary.opacity(0.2)
                            }
                        }()

                        ZStack {
                            Circle()
                                .frame(width: 50)
                                .foregroundStyle(rankColor)

                            Text(String(index + 1))
                                .foregroundStyle(Color.primary)
                        }

                        Text(item.name)

                        Spacer()

                        Text(String(item.tagCount))
                    }
                    .padding()
                }
                .padding(2)
            }
        }
        .padding(12)
        Spacer()
    }
}


#Preview {
    LeaderboardView()
}
