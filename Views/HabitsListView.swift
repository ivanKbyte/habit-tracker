//
//  HabitsListView.swift
//  habit-tracker
//
//  Created by Ivan Kharitonenko on 31/10/2025.
//


import SwiftUI
import SwiftData

struct HabitsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    @State private var showingAddHabit = false
    @State private var selectedHabit: Habit?
    
    var body: some View {
        NavigationStack {
            if habits.isEmpty {
                emptyStateView
            } else {
                List {
                    ForEach(habits) { habit in
                        Button {
                            selectedHabit = habit
                        } label: {
                            HabitListRow(habit: habit)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .onDelete(perform: deleteHabits)
                }
                .listStyle(.plain)
            }
        }
        .navigationTitle("All Habits")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showingAddHabit = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .symbolRenderingMode(.hierarchical)
                }
            }
            
            if !habits.isEmpty {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
            }
        }
        .sheet(isPresented: $showingAddHabit) {
            AddHabitView()
        }
        .sheet(item: $selectedHabit) { habit in
            HabitDetailView(habit: habit)
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "list.bullet.circle")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("No Habits Yet")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Create habits to start tracking your progress")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button {
                showingAddHabit = true
            } label: {
                Label("Create Habit", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
            }
            .padding(.top, 8)
        }
    }
    
    private func deleteHabits(at offsets: IndexSet) {
        for index in offsets {
            let habit = habits[index]
            modelContext.delete(habit)
        }
    }
}

struct HabitListRow: View {
    let habit: Habit
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(habit.colorValue.opacity(0.15))
                    .frame(width: 50, height: 50)
                
                Image(systemName: habit.iconName)
                    .font(.title3)
                    .foregroundColor(habit.colorValue)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(habit.name)
                    .font(.headline)
                
                HStack(spacing: 16) {
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text("\(habit.currentStreak()) streak")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    HStack(spacing: 4) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                        Text("\(habit.completions.count) total")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    HabitsListView()
        .modelContainer(for: [Habit.self, HabitCompletion.self], inMemory: true)
}