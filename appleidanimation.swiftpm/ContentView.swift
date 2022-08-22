import SwiftUI

// Recreating the animation on https://appleid.apple.com using SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            grayBackground
            animatingDots
            appleLogo
        }
    }
    
    private var grayBackground: some View {
        Color(white: 248/255)
            .edgesIgnoringSafeArea(.all)
    }
    
    private var animatingDots: some View {
        ZStack {
            gradientBackground
                .mask {
                    ZStack {
                        AnimatedDots(delay: 0)
                        AnimatedDots(delay: 0.2)
                            .scaleEffect(0.88)
                            .rotationEffect(.degrees(360/48))
                        AnimatedDots(delay: 0.4)
                            .scaleEffect(0.88 * 0.88)
                        AnimatedDots(delay: 0.6)
                            .scaleEffect(0.88 * 0.88 * 0.88)
                            .rotationEffect(.degrees(360/48))
                        AnimatedDots(delay: 0.8)
                            .scaleEffect(0.88 * 0.88 * 0.88 * 0.88)
                        AnimatedDots(delay: 1)
                            .scaleEffect(0.88 * 0.88 * 0.88 * 0.88 * 0.88)
                            .rotationEffect(.degrees(360/48))
                        AnimatedDots(delay: 1.2)
                            .scaleEffect(0.88 * 0.88 * 0.88 * 0.88 * 0.88 * 0.88)
                        AnimatedDots(delay: 1.4)
                            .scaleEffect(0.88 * 0.88 * 0.88 * 0.88 * 0.88 * 0.88 * 0.88)
                            .rotationEffect(.degrees(360/48))
                        AnimatedDots(delay: 1.6)
                            .scaleEffect(0.88 * 0.88 * 0.88 * 0.88 * 0.88 * 0.88 * 0.88 * 0.88)
                    }
                }
        }
    }
    
    private var gradientBackground: some View {
        AngularGradient(colors: [.cyan, .indigo, .pink, .orange, .cyan], center: .center, startAngle: .degrees(-45), endAngle: .degrees(360-45))
    }
    
    private var appleLogo: some View {
        Image(systemName: "applelogo")
            .foregroundColor(.black)
            .font(Font.system(size: 90))
            .offset(y: -5)
    }
}

struct AnimatedDots: View {
    let delay: Double

    @State private var animating = false
    @State private var rotation = 0.0
    private let timer = Timer.publish(every: 2.25, on: .main, in: .common).autoconnect()
    
    var body: some View {
        dots
            .opacity(animating ? 1 : 0)
            .scaleEffect(animating ? 1 : 0.5)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                fadeIn()
            }
            .onReceive(timer) { _ in
                if animating {
                    fadeOut()
                } else {
                    fadeIn()
                }
            }
    }

    private func fadeIn() {
        withAnimation(.spring(response: 0.9, dampingFraction: 0.4, blendDuration: 1.8).delay(delay/2.0)) {
//            rotation += 360/24
            animating = true
        }
    }

    private func fadeOut() {
        withAnimation(.easeIn(duration: 0.4).delay(2 - delay/10.0)) {
//            rotation += 360/24
            animating = false
        }
    }
    
    private var dots: some View {
        Canvas { context, size in
            let dimensionOffset = size.width/2
            let image = context.resolve(Image(systemName: "circle.fill"))
            var currentPoint = CGPoint(x: dimensionOffset - image.size.width/2, y: 0)
            
            for _ in 0...24 {
                currentPoint = currentPoint.applying(.init(rotationAngle: Angle.degrees(360/24).radians))
                context.draw(image, at: CGPoint(x: currentPoint.x + dimensionOffset, y: currentPoint.y + dimensionOffset))
            }
        }
        .frame(width: 390, height: 390)
        .rotationEffect(.degrees(360/48))
    }
}
