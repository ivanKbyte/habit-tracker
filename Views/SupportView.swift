//
//  SupportView.swift
//  habit-tracker
//
//  Created by Ivan Kharitonenko on 04/11/2025.
//


import SwiftUI

struct SupportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedQuestion: FAQItem?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    faqSection
                    contactSection
                }
                .padding()
            }
            .navigationTitle("Help & Support")
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
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue.opacity(0.2), .purple.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            Text("How can we help?")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Find answers to common questions or contact us")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical)
    }
    
    private var faqSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Frequently Asked Questions")
                .font(.headline)
            
            VStack(spacing: 12) {
                ForEach(faqItems) { item in
                    FAQRow(
                        item: item,
                        isExpanded: selectedQuestion?.id == item.id
                    ) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            selectedQuestion = selectedQuestion?.id == item.id ? nil : item
                        }
                    }
                }
            }
        }
    }
    
    private var contactSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Still need help?")
                .font(.headline)
            
            VStack(spacing: 12) {
                ContactButton(
                    icon: "envelope.fill",
                    title: "Email Support",
                    subtitle: "support@habittracker.com",
                    color: .blue
                ) {
                    // Would open email
                }
                
                ContactButton(
                    icon: "message.fill",
                    title: "Live Chat",
                    subtitle: "Available 9 AM - 5 PM EST",
                    color: .green
                ) {
                    // Would open chat
                }
            }
        }
    }
    
    private let faqItems: [FAQItem] = [
        FAQItem(
            question: "How do I create a new habit?",
            answer: "Tap the '+' button on the Today or Habits tab. Choose an icon, color, and name for your habit. You can customize it anytime by tapping on the habit."
        ),
        FAQItem(
            question: "How are streaks calculated?",
            answer: "Your streak increases by 1 each day you complete a habit. If you miss a day, the streak resets to 0. Your best streak is saved and displayed in statistics."
        ),
        FAQItem(
            question: "Can I edit or delete habits?",
            answer: "Yes! Tap any habit to view details, then use the menu button (•••) to edit or delete. You can also swipe left on habits in the list view."
        ),
        FAQItem(
            question: "Is my data backed up?",
            answer: "Your habits are stored locally on your device and synced with your account. As long as you're signed in, your data is safe."
        ),
        FAQItem(
            question: "How do I reset my password?",
            answer: "On the login screen, tap 'Forgot Password?' Enter your email and we'll send you instructions to reset your password."
        )
    ]
}

struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

struct FAQRow: View {
    let item: FAQItem
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(item.question)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                
                if isExpanded {
                    Text(item.answer)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(.plain)
    }
}

struct ContactButton: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SupportView()
}