import SwiftUI

struct LoginView: View {
    @StateObject private var authManager = AuthenticationManager()
    @State private var email = ""
    @State private var password = ""
    @State private var showPassword = false
    @State private var showSignUp = false
    @State private var showForgotPassword = false
    @State private var showError = false
    @FocusState private var focusedField: Field?
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background gradient
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
                        Spacer(minLength: 60)
                        
                        // Logo and title
                        headerSection
                        
                        // Login form
                        loginFormSection
                        
                        // Sign in button
                        signInButton
                        
                        // Forgot password
                        forgotPasswordButton
                        
                        // Divider
                        dividerSection
                        
                        // Sign up button
                        signUpButton
                        
                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 24)
                }
            }
            .navigationBarHidden(true)
            .alert("Error", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(authManager.errorMessage ?? "An error occurred")
            }
            .fullScreenCover(isPresented: $showSignUp) {
                SignUpView()
            }
            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView()
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
            .padding(.bottom, 8)
            
            Text("Welcome Back")
                .font(.system(size: 32, weight: .bold, design: .rounded))
            
            Text("Sign in to continue tracking your habits")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var loginFormSection: some View {
        VStack(spacing: 16) {
            // Email field
            CustomTextField(
                icon: "envelope.fill",
                placeholder: "Email",
                text: $email,
                isSecure: false
            )
            .focused($focusedField, equals: .email)
            .textInputAutocapitalization(.never)
            .keyboardType(.emailAddress)
            .submitLabel(.next)
            .onSubmit {
                focusedField = .password
            }
            
            // Password field
            CustomTextField(
                icon: "lock.fill",
                placeholder: "Password",
                text: $password,
                isSecure: !showPassword,
                showPasswordToggle: true,
                showPassword: $showPassword
            )
            .focused($focusedField, equals: .password)
            .submitLabel(.go)
            .onSubmit {
                Task {
                    await signIn()
                }
            }
        }
    }
    
    private var signInButton: some View {
        Button {
            Task {
                await signIn()
            }
        } label: {
            HStack {
                if authManager.isLoading {
                    CustomLoadingView(tintColor: .white)
                } else {
                    Text("Sign In")
                        .font(.headline)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .foregroundColor(.white)
            .background(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .disabled(authManager.isLoading || email.isEmpty || password.isEmpty)
        .opacity(authManager.isLoading || email.isEmpty || password.isEmpty ? 0.6 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: authManager.isLoading)
    }
    
    private var forgotPasswordButton: some View {
        Button {
            showForgotPassword = true
        } label: {
            Text("Forgot Password?")
                .font(.subheadline)
                .foregroundColor(.blue)
        }
    }
    
    private var dividerSection: some View {
        HStack(spacing: 16) {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
            
            Text("OR")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
        }
        .padding(.vertical, 8)
    }
    
    private var signUpButton: some View {
        Button {
            showSignUp = true
        } label: {
            HStack(spacing: 4) {
                Text("Don't have an account?")
                    .foregroundColor(.secondary)
                Text("Sign Up")
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
            .font(.subheadline)
        }
    }
    
    private func signIn() async {
        guard !email.isEmpty, !password.isEmpty else { return }
        
        do {
            try await authManager.signIn(email: email, password: password)
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } catch {
            showError = true
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.error)
        }
    }
}

struct CustomTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var showPasswordToggle: Bool = false
    @Binding var showPassword: Bool
    
    init(icon: String, placeholder: String, text: Binding<String>, isSecure: Bool = false, showPasswordToggle: Bool = false, showPassword: Binding<Bool> = .constant(false)) {
        self.icon = icon
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.showPasswordToggle = showPasswordToggle
        self._showPassword = showPassword
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 20)
            
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
            
            if showPasswordToggle {
                Button {
                    showPassword.toggle()
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                } label: {
                    Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

#Preview {
    LoginView()
}
