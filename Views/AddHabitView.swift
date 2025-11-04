//
//  AddHabitView.swift
//  habit-tracker
//
//  Created by Ivan Kharitonenko on 31/10/2025.
//


import SwiftUI
import SwiftData

struct AddHabitView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var habitName = ""
    @State private var selectedIcon = "star.fill"
    @State private var selectedColor = "blue"
    @State private var frequency = "daily"
    
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
                        .font(.body)
                }
                
                Section("Icon") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 16) {
                        ForEach(habitIcons, id: \.self) { icon in
                            IconButton(
                                icon: icon,
                                color: getColor(selectedColor),
                                isSelected: selectedIcon == icon
                            ) {
                                let generator = UISelectionFeedbackGenerator()
                                generator.selectionChanged()
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
                                let generator = UISelectionFeedbackGenerator()
                                generator.selectionChanged()
                                selectedColor = color
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("Preview") {
                    HStack(spacing: 16) {
                        ZStack {
                            Circle()
                                .fill(getColor(selectedColor).opacity(0.15))
                                .frame(width: 56, height: 56)
                            
                            Image(systemName: selectedIcon)
                                .font(.title2)
                                .foregroundColor(getColor(selectedColor))
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(habitName.isEmpty ? "Your Habit" : habitName)
                                .font(.headline)
                            
                            Text("0 day streak")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addHabit()
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
    
    private func addHabit() {
        let habit = Habit(
            name: habitName.trimmingCharacters(in: .whitespacesAndNewlines),
            iconName: selectedIcon,
            color: selectedColor,
            frequency: frequency
        )
        modelContext.insert(habit)
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
        
        dismiss()
    }
}

#Preview {
    AddHabitView()
        .modelContainer(for: [Habit.self, HabitCompletion.self], inMemory: true)
}