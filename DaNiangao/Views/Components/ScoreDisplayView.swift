import SwiftUI

struct ScoreDisplayView: View {
    let score: Int
    let targetScore: Int
    let hits: Int
    let requiredHits: Int

    var body: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    Text("得分")
                        .font(GameFonts.caption)
                        .foregroundStyle(GameColors.text.opacity(0.6))

                    Text("\(score)")
                        .font(GameFonts.score)
                        .foregroundStyle(GameColors.primary)
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Text("目标")
                        .font(GameFonts.caption)
                        .foregroundStyle(GameColors.text.opacity(0.6))

                    Text("\(targetScore)")
                        .font(GameFonts.body)
                        .foregroundStyle(GameColors.text.opacity(0.8))
                }
            }

            HStack {
                Text("命中: \(hits)/\(requiredHits)")
                    .font(GameFonts.caption)
                    .foregroundStyle(hits >= requiredHits ? GameColors.success : GameColors.text.opacity(0.6))

                Spacer()

                if score >= targetScore {
                    Text("✓ 达成目标")
                        .font(GameFonts.caption)
                        .foregroundStyle(GameColors.success)
                }
            }
        }
        .padding(15)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.8))
                .shadow(color: .black.opacity(0.05), radius: 5)
        )
    }
}