//
//  LaunchScreenView.swift
//  habit-tracker
//
//  Created by Ivan Kharitonenko on 04/11/2025.
//


import SwiftUI

struct LaunchScreenView: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.blue.opacity(0.3),
                    Color.purple.opacity(0.3)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .shadow(color: .blue.opacity(0.5), radius: 25, x: 0, y: 10)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                }
                .scaleEffect(scale)
                .opacity(opacity)
                
                Text("HabitTracker")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.65)) {
                scale = 1.0
                opacity = 1.0
            }
        }
    }
}

#Preview {
    LaunchScreenView()
}
