//
//  ConfettiView.swift
//  habit-tracker
//
//  Created by Ivan Kharitonenko on 31/10/2025.
//


import SwiftUI

struct ConfettiView: View {
    @Binding var trigger: Int
    @State private var particles: [ConfettiParticle] = []
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
            }
        }
        .allowsHitTesting(false)
        .onChange(of: trigger) { _, _ in
            createConfetti()
        }
    }
    
    private func createConfetti() {
        let colors: [Color] = [.blue, .purple, .pink, .orange, .yellow, .green]
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        particles = []
        
        for _ in 0..<50 {
            let particle = ConfettiParticle(
                color: colors.randomElement()!,
                position: CGPoint(x: screenWidth / 2, y: screenHeight / 2),
                size: CGFloat.random(in: 6...12)
            )
            particles.append(particle)
        }
        
        // Animate particles
        withAnimation(.easeOut(duration: 1.5)) {
            for i in particles.indices {
                let angle = Double.random(in: 0...(2 * .pi))
                let distance = CGFloat.random(in: 100...300)
                let endX = particles[i].position.x + cos(angle) * distance
                let endY = particles[i].position.y + sin(angle) * distance
                
                particles[i].position = CGPoint(x: endX, y: endY)
                particles[i].opacity = 0
            }
        }
        
        // Clear particles after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            particles = []
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id = UUID()
    let color: Color
    var position: CGPoint
    let size: CGFloat
    var opacity: Double = 1.0
}

#Preview {
    ConfettiView(trigger: .constant(0))
}