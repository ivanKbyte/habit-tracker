//
//  SignUpView 2.swift
//  habit-tracker
//
//  Created by Ivan Kharitonenko on 04/11/2025.
//


import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var authManager = AuthenticationManager()
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var showPassword = false
    @State private var showConfirmPassword = false
    @State private var showError = false
    @State private var agreeToTerms = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case fullName, email, password, confirmPassword
    }
    
    private var isFormValid: Bool {
        !fullName.isEmpty &&
        !email.isEmpty &&
        isValidEmail(email) &&
        !password.isEmpty &&
        password.count >= 6 &&
        password == confirmPassword &&
        agreeToTerms
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
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
                
                ScrollView {
                    VStack(spacing: 32) {
                        Spacer(minLength: 40)
                        
                        headerSection
                        signUpFormSection
                        termsSection
                        signUpButton
                        signInSection
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 24)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title3)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.gray)
                    }
                }
            }
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(authManager.errorMessage ?? "An error occurred")
            }
            .fullScreenCover(isPresented: $authManager.isAuthenticated) {
                ContentView()
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 90, height: 90)
                    .shadow(color: .purple.opacity(0.3), radius: 20, x: 0, y: 10)
                
                Image(systemName: "person.badge.plus.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
            }
            
            Text("Create Account")
                .font(.system(size: 32, weight: .bold, design: .rounded))
            
            Text("Join us to start your habit journey")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var signUpFormSection: some View {
        VStack(spacing: 16) {
            CustomTextField(
                icon: "person.fill",
                placeholder: "Full Name",
                text: $fullName
            )
            .focused($focusedField, equals: .fullName)
            .textInputAutocapitalization(.words)
            .submitLabel(.next)
            .onSubmit {
                focusedField = .email
            }
            
            CustomTextField(
                icon: "envelope.fill",
                placeholder: "Email",
                text: $email
            )
            .focused($focusedField, equals: .email)
            .textInputAutocapitalization(.never)
            .keyboardType(.emailAddress)
            .submitLabel(.next)
            .onSubmit {
                focusedField = .password
            }
            
            CustomTextField(
                icon: "lock.fill",
                placeholder: "Password (min. 6 characters)",
                text: $password,
                isSecure: !showPassword,
                showPasswordToggle: true,
                showPassword: $showPassword
            )
            .focused($focusedField, equals: .password)
            .submitLabel(.next)
            .onSubmit {
                focusedField = .confirmPassword
            }
            
            CustomTextField(
                icon: "lock.fill",
                placeholder: "Confirm Password",
                text: $confirmPassword,
                isSecure: !showConfirmPassword,
                showPasswordToggle: true,
                showPassword: $showConfirmPassword
            )
            .focused($focusedField, equals: .confirmPassword)
            .submitLabel(.go)
            .onSubmit {
                Task {
                    await signUp()
                }
            }
            
            if !password.isEmpty && !confirmPassword.isEmpty && password != confirmPassword {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.red)
                    Text("Passwords don't match")
                        .font(.caption)
                        .foregroundColor(.red)
                    Spacer()
                }
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: password)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: confirmPassword)
    }
    
    private var termsSection: some View {
        HStack(alignment: .top, spacing: 12) {
            Button {
                agreeToTerms.toggle()
                let generator = UIImpactFeedbackGenerator(style: .light)
                generator.impactOccurred()
            } label: {
                Image(systemName: agreeToTerms ? "checkmark.square.fill" : "square")
                    .font(.title3)
                    .foregroundColor(agreeToTerms ? .blue : .gray)
            }
            
            Text("I agree to the Terms of Service and Privacy Policy")
                .font(.caption)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: agreeToTerms)
    }
    
    private var signUpButton: some View {
        Button {
            Task {
                await signUp()
            }
        } label: {
            HStack {
                if authManager.isLoading {
                    CustomLoadingView(tintColor: .white)
                } else {
                    Text("Create Account")
                        .font(.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .foregroundColor(.white)
            .background(
                LinearGradient(
                    colors: [.purple, .blue],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: .purple.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .disabled(!isFormValid || authManager.isLoading)
        .opacity(isFormValid && !authManager.isLoading ? 1.0 : 0.6)
        .animation(.easeInOut(duration: 0.2), value: isFormValid)
        .animation(.easeInOut(duration: 0.2), value: authManager.isLoading)
    }
    
    private var signInSection: some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: 4) {
                Text("Already have an account?")
                    .foregroundColor(.secondary)
                Text("Sign In")
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            .font(.subheadline)
        }
    }
    
    private func signUp() async {
        guard isFormValid else { return }
        
        do {
            try await authManager.signUp(email: email, password: password, fullName: fullName)
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
    SignUpView()
}