//
//  StatisticsView.swift
//  habit-tracker
//
//  Created by Ivan Kharitonenko on 31/10/2025.
//


import SwiftUI
import SwiftData
import Charts

struct StatisticsView: View {
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    
    private var totalCompletions: Int {
        habits.reduce(0) { $0 + $1.completions.count }
    }
    
    private var averageCompletionRate: Double {
        guard !habits.isEmpty else { return 0 }
        let totalRate = habits.reduce(0.0) { $0 + $1.completionRate(days: 30) }
        return totalRate / Double(habits.count)
    }
    
    private var bestStreak: Int {
        habits.map { $0.bestStreak() }.max() ?? 0
    }
    
    private var currentStreaks: Int {
        habits.reduce(0) { $0 + $1.currentStreak() }
    }
    
    var body: some View {
        NavigationStack {
            if habits.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    VStack(spacing: 24) {
                        statsCardsSection
                        weeklyActivitySection
                        habitsBreakdownSection
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Statistics")
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar.fill")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("No Stats Yet")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Start tracking habits to see your progress")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var statsCardsSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            StatCard(
                title: "Total Check-ins",
                value: "\(totalCompletions)",
                icon: "checkmark.circle.fill",
                color: .blue
            )
            
            StatCard(
                title: "Best Streak",
                value: "\(bestStreak)",
                icon: "flame.fill",
                color: .orange
            )
            
            StatCard(
                title: "Active Streaks",
                value: "\(currentStreaks)",
                icon: "bolt.fill",
                color: .yellow
            )
            
            StatCard(
                title: "Completion Rate",
                value: "\(Int(averageCompletionRate * 100))%",
                icon: "chart.line.uptrend.xyaxis",
                color: .green
            )
        }
    }
    
    private var weeklyActivitySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weekly Activity")
                .font(.title3)
                .fontWeight(.semibold)
            
            WeeklyHeatmapView(habits: habits)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    private var habitsBreakdownSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Habits Breakdown")
                .font(.title3)
                .fontWeight(.semibold)
            
            ForEach(habits) { habit in
                HabitStatRow(habit: habit)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

struct WeeklyHeatmapView: View {
    let habits: [Habit]
    
    private var last7Days: [Date] {
        let calendar = Calendar.current
        return (0..<7).compactMap { daysAgo in
            calendar.date(byAdding: .day, value: -daysAgo, to: Date())
        }.reversed()
    }
    
    private func completionsCount(for date: Date) -> Int {
        let calendar = Calendar.current
        return habits.reduce(0) { count, habit in
            let completions = habit.completions.filter {
                calendar.isDate($0.date, inSameDayAs: date)
            }
            return count + completions.count
        }
    }
    
    private func intensity(for count: Int) -> Double {
        guard !habits.isEmpty else { return 0 }
        return Double(count) / Double(habits.count)
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(last7Days, id: \.self) { date in
                VStack(spacing: 4) {
                    Text(dayString(for: date))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(color(for: completionsCount(for: date)))
                        .frame(width: 36, height: 48)
                        .overlay(
                            Text("\(completionsCount(for: date))")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(completionsCount(for: date) > 0 ? .white : .secondary)
                        )
                }
            }
        }
    }
    
    private func dayString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return String(formatter.string(from: date).prefix(1))
    }
    
    private func color(for count: Int) -> Color {
        let intensity = self.intensity(for: count)
        if intensity == 0 {
            return Color.gray.opacity(0.1)
        } else if intensity < 0.4 {
            return Color.blue.opacity(0.3)
        } else if intensity < 0.7 {
            return Color.blue.opacity(0.6)
        } else {
            return Color.blue
        }
    }
}

struct HabitStatRow: View {
    let habit: Habit
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(habit.colorValue.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: habit.iconName)
                    .font(.title3)
                    .foregroundColor(habit.colorValue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(habit.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.caption2)
                            .foregroundColor(.orange)
                        Text("\(habit.currentStreak())")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption2)
                            .foregroundColor(.green)
                        Text("\(habit.completions.count)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.caption2)
                            .foregroundColor(.blue)
                        Text("\(Int(habit.completionRate(days: 30) * 100))%")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    StatisticsView()
        .modelContainer(for: [Habit.self, HabitCompletion.self], inMemory: true)
}