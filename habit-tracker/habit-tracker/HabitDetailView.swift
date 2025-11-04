//
//  HabitDetailView.swift
//  habit-tracker
//
//  Created by Ivan Kharitonenko on 31/10/2025.
//


import SwiftUI
import SwiftData

struct HabitDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var habit: Habit
    @State private var showingDeleteAlert = false
    @State private var showingEditSheet = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    headerSection
                    statsSection
                    calendarSection
                }
                .padding()
            }
            .navigationTitle(habit.name)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            showingEditSheet = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive) {
                            showingDeleteAlert = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .font(.title3)
                    }
                }
            }
            .alert("Delete Habit?", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteHabit()
                }
            } message: {
                Text("This will permanently delete \"\(habit.name)\" and all its history.")
            }
            .sheet(isPresented: $showingEditSheet) {
                EditHabitView(habit: habit)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(habit.colorValue.opacity(0.15))
                    .frame(width: 100, height: 100)
                
                Image(systemName: habit.iconName)
                    .font(.system(size: 44))
                    .foregroundColor(habit.colorValue)
            }
            
            VStack(spacing: 8) {
                Text(habit.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                HStack(spacing: 4) {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                    Text("\(habit.currentStreak()) day current streak")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    private var statsSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                StatBox(
                    title: "Total",
                    value: "\(habit.completions.count)",
                    icon: "checkmark.circle.fill",
                    color: .blue
                )
                
                StatBox(
                    title: "Best Streak",
                    value: "\(habit.bestStreak())",
                    icon: "trophy.fill",
                    color: .orange
                )
            }
            
            HStack(spacing: 16) {
                StatBox(
                    title: "This Week",
                    value: "\(completionsThisWeek())",
                    icon: "calendar",
                    color: .green
                )
                
                StatBox(
                    title: "Completion",
                    value: "\(Int(habit.completionRate(days: 30) * 100))%",
                    icon: "chart.line.uptrend.xyaxis",
                    color: .purple
                )
            }
        }
    }
    
    private var calendarSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("History")
                .font(.title3)
                .fontWeight(.semibold)
            
            HabitCalendarView(habit: habit)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    private func completionsThisWeek() -> Int {
        let calendar = Calendar.current
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        return habit.completions.filter { $0.date >= weekStart }.count
    }
    
    private func deleteHabit() {
        modelContext.delete(habit)
        try? modelContext.save()
        dismiss()
    }
}

struct EditHabitView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var habit: Habit
    
    @State private var habitName: String
    @State private var selectedIcon: String
    @State private var selectedColor: String
    
    init(habit: Habit) {
        self.habit = habit
        _habitName = State(initialValue: habit.name)
        _selectedIcon = State(initialValue: habit.iconName)
        _selectedColor = State(initialValue: habit.color)
    }
    
    let habitIcons = [
        "star.fill", "heart.fill", "bolt.fill", "flame.fill",
        "book.fill", "dumbbell.fill", "bed.double.fill", "cup.and.saucer.fill",
        "figure.walk", "music.note", "brain.head.profile", "leaf.fill",
        "drop.fill", "sparkles", "moon.stars.fill", "sun.max.fill"
    ]
    
    let habitColors = [
        "blue", "purple", "pink", "red",
        "orange", "yellow", "green", "teal",
        "indigo", "cyan"
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Habit name", text: $habitName)
                }
                
                Section("Icon") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 16) {
                        ForEach(habitIcons, id: \.self) { icon in
                            IconButton(
                                icon: icon,
                                color: getColor(selectedColor),
                                isSelected: selectedIcon == icon
                            ) {
                                selectedIcon = icon
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Color") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 50))], spacing: 16) {
                        ForEach(habitColors, id: \.self) { color in
                            ColorButton(
                                color: getColor(color),
                                isSelected: selectedColor == color
                            ) {
                                selectedColor = color
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                    .fontWeight(.semibold)
                    .disabled(habitName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
    
    private func getColor(_ colorName: String) -> Color {
        switch colorName {
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
    
    private func saveChanges() {
        habit.name = habitName.trimmingCharacters(in: .whitespacesAndNewlines)
        habit.iconName = selectedIcon
        habit.color = selectedColor
        dismiss()
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Habit.self, configurations: config)
    
    let habit = Habit(name: "Read", iconName: "book.fill", color: "blue")
    container.mainContext.insert(habit)
    
    return HabitDetailView(habit: habit)
        .modelContainer(container)
}