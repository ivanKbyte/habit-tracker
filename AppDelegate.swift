import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct HabitTrackerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authManager = AuthenticationManager()
    @State private var isLoading = true
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Habit.self,
            HabitCompletion.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ZStack {
                // Keep background consistent to avoid white flash
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.3),
                        Color.purple.opacity(0.3)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                if isLoading {
                    LaunchScreenView()
                        .transition(.opacity)
                } else {
                    if authManager.isAuthenticated {
                        ContentView()
                            .transition(.opacity)
                    } else {
                        LoginView()
                            .transition(.opacity)
                    }
                }
            }
            .animation(.easeInOut(duration: 0.4), value: isLoading)
            .animation(.easeInOut(duration: 0.4), value: authManager.isAuthenticated)
            .preferredColorScheme(isDarkMode ? .dark : nil)
            .onAppear {
                // Shorter delay - just enough for smooth animation
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation {
                        isLoading = false
                    }
                }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
