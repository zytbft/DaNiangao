import SwiftUI

struct HammerView: View {
    let isHitting: Bool

    @State private var offsetY: CGFloat = 0
    @State private var rotation: Double = -15

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: "8B5A2B"),
                                Color(hex: "6B4226"),
                                Color(hex: "8B5A2B")
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 22, height: 140)

                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(hex: "5C3D1E"), lineWidth: 2)
                    .frame(width: 22, height: 140)

                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            colors: [Color(hex: "A0522D"), Color(hex: "8B4513")],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 14, height: 130)

                ForEach(0..<5, id: \.self) { i in
                    Rectangle()
                        .fill(Color(hex: "5C3D1E").opacity(0.3))
                        .frame(width: 14, height: 1)
                        .offset(y: CGFloat(i) * 28 - 56)
                }
            }
            .offset(y: offsetY)
            .rotationEffect(.degrees(rotation))

            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: "A8A8A8"),
                                Color(hex: "787878"),
                                Color(hex: "606060")
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 80, height: 55)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                LinearGradient(
                                    colors: [Color(hex: "C0C0C0"), Color(hex: "505050")],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 4
                            )
                    )

                VStack(spacing: 3) {
                    ForEach(0..<4, id: \.self) { i in
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(hex: "707070"), Color(hex: "505050")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 65, height: 4)
                            .cornerRadius(1)
                    }
                }

                Rectangle()
                    .fill(Color(hex: "909090"))
                    .frame(width: 70, height: 3)
                    .offset(y: -20)

                Rectangle()
                    .fill(Color(hex: "505050"))
                    .frame(width: 70, height: 2)
                    .offset(y: 20)
            }
            .offset(y: offsetY + 55)
            .rotationEffect(.degrees(rotation))
        }
        .onAppear {
            startIdleAnimation()
        }
        .onChange(of: isHitting) { _, newValue in
            if newValue {
                performHitAnimation()
            } else {
                startIdleAnimation()
            }
        }
    }

    private func startIdleAnimation() {
        withAnimation(
            .easeInOut(duration: 1.5)
            .repeatForever(autoreverses: true)
        ) {
            offsetY = -4
        }
    }

    private func performHitAnimation() {
        offsetY = 0
        rotation = -15

        withAnimation(.easeIn(duration: 0.05)) {
            rotation = 25
            offsetY = 75
        }

        withAnimation(.easeOut(duration: 0.06).delay(0.05)) {
            rotation = -5
            offsetY = 65
        }

        withAnimation(.easeInOut(duration: 0.12).delay(0.15)) {
            rotation = -15
            offsetY = 0
        }
    }
}