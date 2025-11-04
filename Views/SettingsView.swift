//
//  SettingsView.swift
//  habit-tracker
//
//  Created by Ivan Kharitonenko on 04/11/2025.
//


import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var notificationsEnabled = true
    @State private var dailyReminderTime = Date()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(isOn: $notificationsEnabled) {
                        HStack(spacing: 12) {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.orange)
                            Text("Enable Notifications")
                        }
                    }
                    .tint(.blue)
                    
                    if notificationsEnabled {
                        DatePicker(
                            selection: $dailyReminderTime,
                            displayedComponents: .hourAndMinute
                        ) {
                            HStack(spacing: 12) {
                                Image(systemName: "clock.fill")
                                    .foregroundColor(.blue)
                                Text("Daily Reminder")
                            }
                        }
                    }
                } header: {
                    Text("Notifications")
                }
                
                Section {
                    Toggle(isOn: $isDarkMode) {
                        HStack(spacing: 12) {
                            Image(systemName: isDarkMode ? "moon.fill" : "sun.max.fill")
                                .foregroundColor(isDarkMode ? .purple : .yellow)
                            Text("Dark Mode")
                        }
                    }
                    .tint(.blue)
                } header: {
                    Text("Appearance")
                } footer: {
                    Text("App will follow system appearance when disabled")
                }
                
                Section {
                    Button {
                        // Would open privacy policy
                    } label: {
                        HStack {
                            Image(systemName: "lock.shield.fill")
                                .foregroundColor(.green)
                            Text("Privacy Policy")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button {
                        // Would open terms
                    } label: {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.blue)
                            Text("Terms of Service")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                } header: {
                    Text("Legal")
                }
                
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("Build")
                        Spacer()
                        Text("2024.1")
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
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
    }
}

#Preview {
    SettingsView()
}