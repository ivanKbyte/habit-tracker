//
//  ProfileView.swift
//  habit-tracker
//
//  Created by Ivan Kharitonenko on 31/10/2025.
//


import SwiftUI
import SwiftData
import FirebaseAuth

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Habit.createdAt) private var habits: [Habit]
    @StateObject private var authManager = AuthenticationManager()
    @State private var showSignOutAlert = false
    @State private var userName: String = ""
    @State private var userEmail: String = ""
    
    private var totalCompletions: Int {
        habits.reduce(0) { $0 + $1.completions.count }
    }
    
    private var daysActive: Int {
        guard let firstHabit = habits.first else { return 0 }
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: firstHabit.createdAt, to: Date()).day ?? 0
        return max(days, 1)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    profileHeaderSection
                    statsSection
                    accountSection
                }
                .padding()
            }
            .navigationTitle("Profile")
            .alert("Sign Out", isPresented: $showSignOutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    signOut()
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
            .onAppear {
                loadUserInfo()
            }
        }
    }
    
    private var profileHeaderSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .shadow(color: .blue.opacity(0.3), radius: 15, x: 0, y: 8)
                
                Text(initials)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text(userName)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(userEmail)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 20)
    }
    
    private var statsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Stats")
                .font(.title3)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                QuickStatCard(
                    title: "Habits",
                    value: "\(habits.count)",
                    icon: "list.bullet",
                    color: .blue
                )
                
                QuickStatCard(
                    title: "Completions",
                    value: "\(totalCompletions)",
                    icon: "checkmark.circle",
                    color: .green
                )
                
                QuickStatCard(
                    title: "Days Active",
                    value: "\(daysActive)",
                    icon: "calendar",
                    color: .orange
                )
                
                QuickStatCard(
                    title: "Avg. Streak",
                    value: "\(averageStreak)",
                    icon: "flame",
                    color: .red
                )
            }
        }
    }
    
    private var accountSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Account")
                .font(.title3)
                .fontWeight(.semibold)
            
            VStack(spacing: 0) {
                ProfileMenuItem(
                    icon: "bell.fill",
                    title: "Notifications",
                    color: .orange
                ) {
                    // Handle notifications
                }
                
                Divider()
                    .padding(.leading, 60)
                
                ProfileMenuItem(
                    icon: "questionmark.circle.fill",
                    title: "Help & Support",
                    color: .blue
                ) {
                    // Handle help
                }
                
                Divider()
                    .padding(.leading, 60)
                
                ProfileMenuItem(
                    icon: "info.circle.fill",
                    title: "About",
                    color: .purple
                ) {
                    // Handle about
                }
                
                Divider()
                    .padding(.leading, 60)
                
                ProfileMenuItem(
                    icon: "arrow.right.square.fill",
                    title: "Sign Out",
                    color: .red,
                    showChevron: false
                ) {
                    showSignOutAlert = true
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
        }
    }
    
    private var initials: String {
        let components = userName.components(separatedBy: " ")
        let initials = components.prefix(2).compactMap { $0.first }.map { String($0) }
        return initials.isEmpty ? "U" : initials.joined().uppercased()
    }
    
    private var averageStreak: Int {
        guard !habits.isEmpty else { return 0 }
        let total = habits.reduce(0) { $0 + $1.currentStreak() }
        return total / habits.count
    }
    
    private func loadUserInfo() {
        // Force refresh user data
        Auth.auth().currentUser?.reload { error in
            if let user = Auth.auth().currentUser {
                userName = user.displayName ?? "User"
                userEmail = user.email ?? ""
            }
        }
    }
    
    private func signOut() {
        do {
            try authManager.signOut()
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } catch {
            print("Error signing out: \(error)")
        }
    }
}

struct QuickStatCard: View {
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
                .font(.system(size: 24, weight: .bold, design: .rounded))
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let color: Color
    var showChevron: Bool = true
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 28)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if showChevron {
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(16)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ProfileView()
        .modelContainer(for: [Habit.self, HabitCompletion.self], inMemory: true)
}