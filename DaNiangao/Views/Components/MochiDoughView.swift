import SwiftUI

struct MochiDoughView: View {
    let position: Double
    let pathWidth: CGFloat
    let isAnimating: Bool
    let pattern: MochiPattern
    let skinColor: MochiSkinColor

    @State private var scale: CGFloat = 1.0
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: skinColor.gradientColors,
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: GameConstants.doughSize / 2
                    )
                )
                .frame(width: GameConstants.doughSize, height: GameConstants.doughSize)
                .shadow(color: .black.opacity(0.25), radius: 6, x: 3, y: 3)

            MochiPatternView(pattern: pattern, skinColor: skinColor)
                .frame(width: GameConstants.doughSize - 8, height: GameConstants.doughSize - 8)
                .clipShape(Circle())

            Circle()
                .stroke(skinColor.gradientColors[1].opacity(0.6), lineWidth: 2)
                .frame(width: GameConstants.doughSize - 4, height: GameConstants.doughSize - 4)

            Circle()
                .fill(Color.white.opacity(0.5))
                .frame(width: 15, height: 15)
                .offset(x: -18, y: -18)
        }
        .scaleEffect(scale)
        .rotationEffect(.degrees(rotation))
        .onChange(of: isAnimating) { _, newValue in
            if newValue {
                withAnimation(.easeOut(duration: 0.12)) {
                    scale = 1.25
                }
                withAnimation(.easeInOut(duration: 0.25).delay(0.12)) {
                    scale = 1.0
                    rotation = 360
                }
            }
        }
        .onChange(of: position) { _, _ in
            if !isAnimating {
                rotation = Double(position * 25)
            }
        }
    }
}

struct MochiPatternView: View {
    let pattern: MochiPattern
    let skinColor: MochiSkinColor

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let maxRadius = min(size.width, size.height) / 2 - 4

            switch pattern {
            case .swirl:
                drawSwirl(context: context, center: center, maxRadius: maxRadius)
            case .zigzag:
                drawZigzag(context: context, center: center, maxRadius: maxRadius)
            case .dots:
                drawDots(context: context, center: center, maxRadius: maxRadius)
            case .waves:
                drawWaves(context: context, center: center, maxRadius: maxRadius)
            case .spiral:
                drawSpiral(context: context, center: center, maxRadius: maxRadius)
            case .burst:
                drawBurst(context: context, center: center, maxRadius: maxRadius)
            }
        }
    }

    private func drawSwirl(context: GraphicsContext, center: CGPoint, maxRadius: CGFloat) {
        let color = skinColor.patternColor
        let density: CGFloat = 2.5

        for i in 0..<Int(maxRadius * density) {
            let progress = CGFloat(i) / (maxRadius * density)
            let angle = progress * 8 * .pi
            let radius = progress * maxRadius
            let x = center.x + cos(angle) * radius
            let y = center.y + sin(angle) * radius

            let pointSize: CGFloat = 2.5 * (1 - progress * 0.5)
            let opacity = 0.4 * (1 - progress * 0.6)

            let rect = CGRect(x: x - pointSize/2, y: y - pointSize/2, width: pointSize, height: pointSize)
            context.fill(Circle().path(in: rect), with: .color(color.opacity(opacity)))
        }
    }

    private func drawZigzag(context: GraphicsContext, center: CGPoint, maxRadius: CGFloat) {
        let color = skinColor.patternColor
        let segments = 12

        for i in 0..<segments {
            let angle1 = (CGFloat(i) / CGFloat(segments)) * .pi * 2
            let angle2 = ((CGFloat(i) + 0.5) / CGFloat(segments)) * .pi * 2

            let innerR = maxRadius * 0.3
            let outerR = maxRadius * (0.6 + CGFloat(i % 3) * 0.15)

            let p1 = CGPoint(x: center.x + cos(angle1) * innerR, y: center.y + sin(angle1) * innerR)
            let p2 = CGPoint(x: center.x + cos(angle2) * outerR, y: center.y + sin(angle2) * outerR)

            var path = Path()
            path.move(to: p1)
            path.addLine(to: p2)

            context.stroke(path, with: .color(color.opacity(0.45)), lineWidth: 2.5)
        }
    }

    private func drawDots(context: GraphicsContext, center: CGPoint, maxRadius: CGFloat) {
        let color = skinColor.patternColor

        for ring in 1...4 {
            let radius = maxRadius * CGFloat(ring) / 5.0
            let dotsInRing = ring * 6

            for i in 0..<dotsInRing {
                let angle = (CGFloat(i) / CGFloat(dotsInRing)) * .pi * 2 + CGFloat(ring) * 0.3
                let x = center.x + cos(angle) * radius
                let y = center.y + sin(angle) * radius

                let dotSize: CGFloat = 3.0 - CGFloat(ring) * 0.4
                let opacity = 0.5 - CGFloat(ring) * 0.08

                let rect = CGRect(x: x - dotSize/2, y: y - dotSize/2, width: dotSize, height: dotSize)
                context.fill(Circle().path(in: rect), with: .color(color.opacity(opacity)))
            }
        }
    }

    private func drawWaves(context: GraphicsContext, center: CGPoint, maxRadius: CGFloat) {
        let color = skinColor.patternColor

        for i in 0..<5 {
            let baseRadius = maxRadius * 0.25 + maxRadius * 0.15 * CGFloat(i)
            let opacity = 0.5 - CGFloat(i) * 0.08

            var path = Path()
            path.addArc(center: center, radius: baseRadius, startAngle: .zero, endAngle: Angle(degrees: 324), clockwise: false)

            context.stroke(path, with: .color(color.opacity(opacity)), lineWidth: 2)
        }
    }

    private func drawSpiral(context: GraphicsContext, center: CGPoint, maxRadius: CGFloat) {
        let color = skinColor.patternColor
        let tightness: CGFloat = 3.0

        var path = Path()
        var isFirst = true

        for i in 0..<Int(maxRadius * 3) {
            let progress = CGFloat(i) / (maxRadius * 3)
            let angle = progress * tightness * .pi
            let radius = progress * maxRadius
            let x = center.x + cos(angle) * radius
            let y = center.y + sin(angle) * radius

            if isFirst {
                path.move(to: CGPoint(x: x, y: y))
                isFirst = false
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        context.stroke(path, with: .color(color.opacity(0.4)), lineWidth: 2)
    }

    private func drawBurst(context: GraphicsContext, center: CGPoint, maxRadius: CGFloat) {
        let color = skinColor.patternColor
        let rays = 16

        for i in 0..<rays {
            let angle1 = (CGFloat(i) / CGFloat(rays)) * .pi * 2
            let angle3 = ((CGFloat(i) + 0.4) / CGFloat(rays)) * .pi * 2

            let innerR = maxRadius * 0.15
            let midR = maxRadius * (0.5 + CGFloat(i % 2) * 0.15)

            let p1 = CGPoint(x: center.x + cos(angle1) * innerR, y: center.y + sin(angle1) * innerR)
            let mid = CGPoint(x: center.x + cos(angle1) * midR, y: center.y + sin(angle1) * midR)
            let p3 = CGPoint(x: center.x + cos(angle3) * innerR, y: center.y + sin(angle3) * innerR)

            var path = Path()
            path.move(to: p1)
            path.addQuadCurve(to: p3, control: mid)

            context.stroke(path, with: .color(color.opacity(0.35)), lineWidth: 2.5)
        }
    }
}