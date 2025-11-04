//
//  ContentView 2.swift
//  habit-tracker
//
//  Created by Ivan Kharitonenko on 31/10/2025.
//


import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            TodayView()
                .tabItem {
                    Label("Today", systemImage: "checkmark.circle.fill")
                }
            
            StatisticsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
            
            HabitsListView()
                .tabItem {
                    Label("Habits", systemImage: "list.bullet")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
        }
        .tint(.blue)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Habit.self, HabitCompletion.self], inMemory: true)
}
