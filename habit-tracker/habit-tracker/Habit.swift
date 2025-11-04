//
//  Habit.swift
//  habit-tracker
//
//  Created by Ivan Kharitonenko on 31/10/2025.
//


import Foundation
import SwiftData
import SwiftUI

@Model
final class Habit {
    var id: UUID
    var name: String
    var iconName: String
    var color: String
    var frequency: String // "daily" or "weekly"
    var targetDays: [Int] // For weekly: 0-6 (Sun-Sat), for daily: empty
    var createdAt: Date
    var completions: [HabitCompletion]
    
    init(name: String, iconName: String, color: String, frequency: String = "daily", targetDays: [Int] = []) {
        self.id = UUID()
        self.name = name
        self.iconName = iconName
        self.color = color
        self.frequency = frequency
        self.targetDays = targetDays
        self.createdAt = Date()
        self.completions = []
    }
    
    var colorValue: Color {
        switch color {
        case "blue": return .blue
        case "purple": return .purple
        case "pink": return .pink
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "green": return .green
        case "teal": return .teal
        case "indigo": return .indigo
        case "cyan": return .cyan
        default: return .blue
        }
    }
    
    func isCompletedToday() -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return completions.contains { completion in
            calendar.isDate(completion.date, inSameDayAs: today)
        }
    }
    
    func currentStreak() -> Int {
        let calendar = Calendar.current
        let sortedCompletions = completions.sorted { $0.date > $1.date }
        
        var streak = 0
        var checkDate = calendar.startOfDay(for: Date())
        
        // If not completed today, start from yesterday
        if !isCompletedToday() {
            checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
        }
        
        for completion in sortedCompletions {
            let completionDate = calendar.startOfDay(for: completion.date)
            if calendar.isDate(completionDate, inSameDayAs: checkDate) {
                streak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
            } else if completionDate < checkDate {
                break
            }
        }
        
        return streak
    }
    
    func bestStreak() -> Int {
        guard !completions.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let sortedCompletions = completions.sorted { $0.date < $1.date }
        
        var maxStreak = 1
        var currentStreak = 1
        
        for i in 1..<sortedCompletions.count {
            let prevDate = calendar.startOfDay(for: sortedCompletions[i-1].date)
            let currDate = calendar.startOfDay(for: sortedCompletions[i].date)
            
            let daysDiff = calendar.dateComponents([.day], from: prevDate, to: currDate).day ?? 0
            
            if daysDiff == 1 {
                currentStreak += 1
                maxStreak = max(maxStreak, currentStreak)
            } else if daysDiff > 1 {
                currentStreak = 1
            }
        }
        
        return maxStreak
    }
    
    func completionRate(days: Int = 30) -> Double {
        let calendar = Calendar.current
        let endDate = Date()
        guard let startDate = calendar.date(byAdding: .day, value: -days, to: endDate) else { return 0 }
        
        let completedDays = completions.filter { $0.date >= startDate && $0.date <= endDate }.count
        return Double(completedDays) / Double(days)
    }
}

@Model
final class HabitCompletion {
    var id: UUID
    var date: Date
    var habit: Habit?
    
    init(date: Date = Date()) {
        self.id = UUID()
        self.date = date
    }
}