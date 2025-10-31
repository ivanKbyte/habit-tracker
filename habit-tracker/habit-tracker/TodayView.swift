//
//  TodayView.swift
//  habit-tracker
//
//  Created by Ivan Kharitonenko on 31/10/2025.
//


import SwiftUI
import SwiftData

struct TodayView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    @State private var showingAddHabit = false
    @State private var confettiTrigger = 0
    
    private var completedCount: Int {
        habits.filter { $0.isCompletedToday() }.count
    }
    
    private var completionPercentage: Double {
        guard !habits.isEmpty else { return 0 }
        return Double(completedCount) / Double(habits.count)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                if habits.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        VStack(spacing: 24) {
                            headerSection
                            habitsSection
                        }
                        .padding()
                    }
                }
                
                ConfettiView(trigger: $confettiTrigger)
            }
            .navigationTitle("Today")
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
            }
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView()
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 12)
                
                Circle()
                    .trim(from: 0, to: completionPercentage)
                    .stroke(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.6, dampingFraction: 0.7), value: completionPercentage)
                
                VStack(spacing: 4) {
                    Text("\(completedCount)")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    Text("of \(habits.count)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 160, height: 160)
            
            Text(motivationalMessage)
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical)
    }
    
    private var motivationalMessage: String {
        if habits.isEmpty {
            return "Add your first habit!"
        } else if completionPercentage == 1.0 {
            return "Perfect day! 🎉"
        } else if completionPercentage >= 0.75 {
            return "Almost there!"
        } else if completionPercentage >= 0.5 {
            return "Keep it up!"
        } else if completionPercentage > 0 {
            return "Great start!"
        } else {
            return "Let's get started!"
        }
    }
    
    private var habitsSection: some View {
        VStack(spacing: 12) {
            ForEach(habits) { habit in
                HabitCardView(habit: habit, onToggle: {
                    toggleHabit(habit)
                })
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: habits.count)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "sparkles")
                .font(.system(size: 80))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text("Start Building Habits")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Track your daily routines and build consistency")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            Button {
                showingAddHabit = true
            } label: {
                Label("Add Your First Habit", systemImage: "plus.circle.fill")
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
    
    private func toggleHabit(_ habit: Habit) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        if habit.isCompletedToday() {
            // Remove today's completion
            if let completion = habit.completions.first(where: {
                Calendar.current.isDateInToday($0.date)
            }) {
                modelContext.delete(completion)
            }
        } else {
            // Add completion
            let completion = HabitCompletion(date: Date())
            completion.habit = habit
            habit.completions.append(completion)
            modelContext.insert(completion)
            
            // Check if all habits completed
            if habits.allSatisfy({ $0.isCompletedToday() }) {
                confettiTrigger += 1
            }
        }
        
        try? modelContext.save()
    }
}

struct HabitCardView: View {
    let habit: Habit
    let onToggle: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button {
            onToggle()
        } label: {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(habit.colorValue.opacity(0.15))
                        .frame(width: 56, height: 56)
                    
                    Image(systemName: habit.iconName)
                        .font(.title2)
                        .foregroundColor(habit.colorValue)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(habit.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .font(.caption)
                        Text("\(habit.currentStreak()) day streak")
                            .font(.subheadline)
                    }
                    .foregroundColor(.orange)
                }
                
                Spacer()
                
                ZStack {
                    Circle()
                        .strokeBorder(habit.colorValue.opacity(0.3), lineWidth: 2.5)
                        .frame(width: 32, height: 32)
                    
                    if habit.isCompletedToday() {
                        Circle()
                            .fill(habit.colorValue)
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: habit.isCompletedToday())
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

#Preview {
    TodayView()
        .modelContainer(for: [Habit.self, HabitCompletion.self], inMemory: true)
}