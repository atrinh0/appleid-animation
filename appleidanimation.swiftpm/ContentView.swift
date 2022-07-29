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
                        AnimatedDots(delay: 0.25)
                            .scaleEffect(0.88)
                            .rotationEffect(.degrees(360/48))
                        AnimatedDots(delay: 0.5)
                            .scaleEffect(0.88 * 0.88)
                        AnimatedDots(delay: 0.75)
                            .scaleEffect(0.88 * 0.88 * 0.88)
                            .rotationEffect(.degrees(360/48))
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
            .offset(y: -9)
    }
}

struct AnimatedDots: View {
    let delay: Double

    @State private var animating = false
    @State private var rotation = 0.0
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
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
        withAnimation(.easeInOut(duration: 1.8).delay(delay)) {
            rotation += 60
            animating = true
        }
    }

    private func fadeOut() {
        withAnimation(.easeInOut(duration: 1.8).delay(1 - delay)) {
            rotation += 60
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
