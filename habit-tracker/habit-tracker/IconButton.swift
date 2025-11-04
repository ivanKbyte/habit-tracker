//
//  IconButton.swift
//  habit-tracker
//
//  Created by Ivan Kharitonenko on 31/10/2025.
//


import SwiftUI

// MARK: - Icon Button
struct IconButton: View {
    let icon: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Circle()
                    .fill(color.opacity(isSelected ? 0.2 : 0.1))
                    .overlay(
                        Circle()
                            .strokeBorder(color, lineWidth: isSelected ? 2 : 0)
                    )
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
            }
            .frame(width: 60, height: 60)
            .scaleEffect(isSelected ? 1.1 : 1.0)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}

// MARK: - Color Button
struct ColorButton: View {
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Circle()
                    .fill(color)
                
                if isSelected {
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 3)
                    
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .frame(width: 50, height: 50)
            .scaleEffect(isSelected ? 1.15 : 1.0)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isSelected)
    }
}

// MARK: - Stat Box
struct StatBox: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - Habit Calendar View
struct HabitCalendarView: View {
    let habit: Habit
    
    private var last30Days: [Date] {
        let calendar = Calendar.current
        return (0..<30).compactMap { daysAgo in
            calendar.date(byAdding: .day, value: -daysAgo, to: Date())
        }.reversed()
    }
    
    private func isCompleted(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return habit.completions.contains { completion in
            calendar.isDate(completion.date, inSameDayAs: date)
        }
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 7), spacing: 8) {
            ForEach(last30Days, id: \.self) { date in
                VStack(spacing: 4) {
                    Text(dayString(for: date))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isCompleted(date) ? habit.colorValue : Color.gray.opacity(0.1))
                        .frame(height: 40)
                        .overlay(
                            Image(systemName: isCompleted(date) ? "checkmark" : "")
                                .font(.caption)
                                .foregroundColor(.white)
                        )
                }
            }
        }
    }
    
    private func dayString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}