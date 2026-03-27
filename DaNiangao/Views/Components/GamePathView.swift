import SwiftUI

struct GamePathView: View {
    let pathWidth: CGFloat
    let pathHeight: CGFloat

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: pathHeight / 2)
                .fill(
                    LinearGradient(
                        colors: [
                            GameColors.pathGradientStart,
                            GameColors.pathGradientEnd,
                            GameColors.pathGradientStart
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: pathWidth, height: pathHeight)

            RoundedRectangle(cornerRadius: pathHeight / 2)
                .stroke(
                    LinearGradient(
                        colors: [
                            GameColors.pathGradientStart.opacity(0.8),
                            GameColors.pathGradientEnd.opacity(0.8)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 3
                )
                .frame(width: pathWidth, height: pathHeight)

            targetZones
        }
    }

    private var targetZones: some View {
        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(GameColors.success.opacity(0.3))
                    .frame(width: pathWidth * 0.15, height: pathHeight * 0.8)
                    .position(
                        x: pathWidth * GameConstants.perfectZoneStart,
                        y: geometry.size.height / 2
                    )

                RoundedRectangle(cornerRadius: 8)
                    .fill(GameColors.primary.opacity(0.2))
                    .frame(width: pathWidth * 0.1, height: pathHeight * 0.8)
                    .position(
                        x: pathWidth * GameConstants.goodZoneStart,
                        y: geometry.size.height / 2
                    )

                Circle()
                    .stroke(GameColors.success, lineWidth: 2)
                    .frame(width: 8, height: 8)
                    .position(
                        x: pathWidth * GameConstants.perfectZoneStart,
                        y: geometry.size.height / 2
                    )
            }
        }
    }
}