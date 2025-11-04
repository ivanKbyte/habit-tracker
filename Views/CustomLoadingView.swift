//
//  CustomLoadingView.swift
//  habit-tracker
//
//  Created by Ivan Kharitonenko on 04/11/2025.
//


import SwiftUI

struct CustomLoadingView: View {
    @State private var isAnimating = false
    var tintColor: Color = .blue
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke(
                    LinearGradient(
                        colors: [tintColor, tintColor.opacity(0.3)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                )
                .frame(width: 24, height: 24)
                .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
                .animation(
                    Animation.linear(duration: 0.8)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
            
            Circle()
                .trim(from: 0, to: 0.3)
                .stroke(
                    tintColor.opacity(0.2),
                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                )
                .frame(width: 24, height: 24)
                .rotationEffect(Angle(degrees: isAnimating ? -360 : 0))
                .animation(
                    Animation.linear(duration: 1.2)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        CustomLoadingView(tintColor: .blue)
        CustomLoadingView(tintColor: .purple)
        CustomLoadingView(tintColor: .white)
            .padding()
            .background(Color.black)
    }
}