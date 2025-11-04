//
//  ForgotPasswordView.swift
//  habit-tracker
//
//  Created by Ivan Kharitonenko on 04/11/2025.
//


import SwiftUI

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var authManager = AuthenticationManager()
    @State private var email = ""
    @State private var showSuccess = false
    @State private var showError = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.1),
                        Color.purple.opacity(0.1)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    Spacer()
                    
                    headerSection
                    formSection
                    resetButton
                    
                    Spacer()
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
            .navigationTitle("Reset Password")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Success", isPresented: $showSuccess) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Password reset email sent! Check your inbox.")
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(authManager.errorMessage ?? "An error occurred")
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.blue, .cyan],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                    .shadow(color: .blue.opacity(0.3), radius: 15, x: 0, y: 8)
                
                Image(systemName: "key.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.white)
            }
            
            Text("Forgot Password?")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Enter your email address and we'll send you instructions to reset your password")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
    
    private var formSection: some View {
        CustomTextField(
            icon: "envelope.fill",
            placeholder: "Email",
            text: $email
        )
        .textInputAutocapitalization(.never)
        .keyboardType(.emailAddress)
    }
    
    private var resetButton: some View {
        Button {
            Task {
                await resetPassword()
            }
        } label: {
            HStack {
                if authManager.isLoading {
                    CustomLoadingView(tintColor: .white)
                } else {
                    Text("Send Reset Link")
                        .font(.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .foregroundColor(.white)
            .background(
                LinearGradient(
                    colors: [.blue, .cyan],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .disabled(email.isEmpty || authManager.isLoading)
        .opacity(email.isEmpty || authManager.isLoading ? 0.6 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: authManager.isLoading)
    }
    
    private func resetPassword() async {
        guard !email.isEmpty else { return }
        
        do {
            try await authManager.resetPassword(email: email)
            showSuccess = true
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } catch {
            showError = true
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
    }
}

#Preview {
    ForgotPasswordView()
}