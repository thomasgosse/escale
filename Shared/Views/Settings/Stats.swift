//
//  Stats.swift
//  Escale
//
//  Created by Thomas Gosse on 07/02/2021.
//

import SwiftUI


struct StatsView: View {
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \LocalLandmark.title, ascending: true)])
    private var localLandmarks: FetchedResults<LocalLandmark>
    
    private var visitedCount: String {
        String(localLandmarks
                .filter({$0.visited == true})
                .count)
    }
    
    private var toVisitCount: String {
        String(localLandmarks
                .filter({$0.visited == false})
                .count)
    }
    
    private var uniqueCountriesCount: String {
        String(
            Dictionary(grouping: localLandmarks, by: {$0.countryCode ?? "N/A"})
                .count)
    }
    
    private var mostVisitedCountry: String {
        let landmark = Dictionary(grouping: localLandmarks, by: {$0.countryCode ?? "N/A"})
            .max { a,b in a.value.filter{$0.visited}.count < b.value.filter{$0.visited}.count }
        let current = Locale(identifier: "fr_FR")
        if let key = landmark?.key {
            return current.localizedString(forRegionCode: key) ?? "N/A"
        }
        return "N/A"
    }
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                StatsCard(visitedCount, "Visités", "checkmark.circle.fill", .purple)
                StatsCard(toVisitCount, "À visiter", "eyes.inverse", .pink)
            }
            HStack(spacing: 10) {
                StatsCard(uniqueCountriesCount, "Pays différents", "globe", .green)
                StatsCard(mostVisitedCountry, "Le plus visité", "heart.fill", .orange)
            }
        }
    }
    
    private struct StatsCard: View {
        private var stats: String
        private var label: String
        private var symbol: String
        private var backgroundColor: Color
        
        init(_ stats: String, _ label: String, _ symbol: String, _ backgroundColor: Color) {
            self.stats = stats
            self.label = label
            self.symbol = symbol
            self.backgroundColor = backgroundColor
        }
        
        var body: some View {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(backgroundColor)
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .center) {
                        Image(systemName: symbol)
                            .font(Font.system(size: 20, weight: .medium))
                        Text(label)
                            .font(.subheadline)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .padding(.leading, -3)
                    
                    Text(stats)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.leading)
                }
            }
            .frame(width: .infinity, height: 100)
        }
    }
}
