//
//  AboutView.swift
//  habit-tracker
//
//  Created by Ivan Kharitonenko on 04/11/2025.
//


import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    appIconSection
                    descriptionSection
                    featuresSection
                    creditsSection
                }
                .padding()
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .environment(\.colorScheme, isDarkMode ? .dark : .light)
    }
    
    private var appIconSection: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                    .shadow(color: .blue.opacity(0.3), radius: 20, x: 0, y: 10)
                
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
            
            Text("HabitTracker")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Version 1.0.0")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical)
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About HabitTracker")
                .font(.headline)
            
            Text("A modern, intuitive habit tracking application designed to help you build better routines and achieve your goals. Track your progress, maintain streaks, and visualize your journey to personal growth.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    private var featuresSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Key Features")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                FeatureRow(icon: "chart.bar.fill", text: "Detailed Analytics", color: .blue)
                FeatureRow(icon: "flame.fill", text: "Streak Tracking", color: .orange)
                FeatureRow(icon: "paintpalette.fill", text: "Customizable Habits", color: .purple)
                FeatureRow(icon: "lock.shield.fill", text: "Secure Authentication", color: .green)
                FeatureRow(icon: "icloud.fill", text: "Cloud Sync", color: .cyan)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    private var creditsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Built With")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("• SwiftUI")
                Text("• SwiftData")
                Text("• Firebase Authentication")
                Text("• Swift Charts")
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            
            Divider()
                .padding(.vertical, 8)
            
            VStack(spacing: 8) {
                Text("© 2024 HabitTracker")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Made with ❤️ for better habits")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 24)
            
            Text(text)
                .font(.subheadline)
        }
    }
}

#Preview {
    AboutView()
}