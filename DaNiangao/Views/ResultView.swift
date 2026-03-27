import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: GameViewModel
    let onReplay: () -> Void
    let onNextLevel: () -> Void
    let onBackToMenu: () -> Void

    @State private var showContent = false

    var body: some View {
        ZStack {
            GameColors.background
                .ignoresSafeArea()

            if let result = viewModel.lastResult {
                VStack(spacing: 30) {
                    Spacer()

                    resultCard(result: result)
                        .opacity(showContent ? 1.0 : 0.0)
                        .scaleEffect(showContent ? 1.0 : 0.8)

                    Spacer()

                    HStack(spacing: 10) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(GameColors.coinGold)
                        Text("当前金币: \(viewModel.totalCoins)")
                            .font(GameFonts.body)
                            .foregroundStyle(GameColors.coinGold)
                    }
                    .opacity(showContent ? 1.0 : 0.0)

                    actionButtons(result: result)
                        .opacity(showContent ? 1.0 : 0.0)

                    Spacer()
                }
                .padding(40)
            } else {
                Text("没有游戏结果")
                    .font(GameFonts.body)
                    .foregroundStyle(GameColors.text)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showContent = true
            }
        }
    }

    private func resultCard(result: GameResult) -> some View {
        VStack(spacing: 25) {
            HStack {
                Text(result.isSuccess ? "🏆" : "💪")
                    .font(.system(size: 60))

                VStack(alignment: .leading, spacing: 5) {
                    Text(result.isSuccess ? "关卡通过!" : "再来一次!")
                        .font(GameFonts.title)
                        .foregroundStyle(result.isSuccess ? GameColors.success : GameColors.fail)

                    Text("关卡 \(result.level)")
                        .font(GameFonts.caption)
                        .foregroundStyle(GameColors.text.opacity(0.6))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 5) {
                    Text(result.rating.rawValue)
                        .font(GameFonts.subtitle)
                        .foregroundStyle(ratingColor(for: result.rating))

                    Text(result.rating.emoji)
                        .font(.system(size: 24))
                }
            }

            Divider()

            HStack(spacing: 40) {
                resultStat(title: "得分", value: "\(result.score)", color: GameColors.primary)
                resultStat(title: "命中", value: "\(result.hits)", color: GameColors.success)
                resultStat(title: "失败", value: "\(result.misses)", color: GameColors.fail)
                resultStat(title: "目标", value: "\(result.targetScore)", color: GameColors.text.opacity(0.6))
            }

            HStack(spacing: 10) {
                Image(systemName: "star.fill")
                    .foregroundStyle(GameColors.coinGold)
                Text("+\(result.coinsEarned) 金币")
                    .font(GameFonts.body)
                    .foregroundStyle(GameColors.coinGold)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 15)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(GameColors.coinGold.opacity(0.2))
            )

            if result.isSuccess {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(GameColors.success)
                    Text("下一关已解锁!")
                        .font(GameFonts.body)
                        .foregroundStyle(GameColors.success)
                }
                .padding(.top, 5)
            }
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
        )
    }

    private func resultStat(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 5) {
            Text(value)
                .font(GameFonts.score)
                .foregroundStyle(color)

            Text(title)
                .font(GameFonts.caption)
                .foregroundStyle(GameColors.text.opacity(0.6))
        }
    }

    private func actionButtons(result: GameResult) -> some View {
        HStack(spacing: 20) {
            Button(action: onBackToMenu) {
                HStack {
                    Image(systemName: "house.fill")
                    Text("返回菜单")
                }
                .font(GameFonts.body)
                .foregroundStyle(.white)
                .frame(width: 160, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.gray)
                )
            }
            .buttonStyle(.plain)

            Button(action: onReplay) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("重玩")
                }
                .font(GameFonts.body)
                .foregroundStyle(.white)
                .frame(width: 140, height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(GameColors.primary)
                )
            }
            .buttonStyle(.plain)

            if result.isSuccess && result.level < 20 {
                Button(action: onNextLevel) {
                    HStack {
                        Image(systemName: "arrow.right")
                        Text("下一关")
                    }
                    .font(GameFonts.body)
                    .foregroundStyle(.white)
                    .frame(width: 160, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(GameColors.success)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func ratingColor(for rating: Rating) -> Color {
        switch rating {
        case .perfect: return GameColors.primary
        case .great: return GameColors.success
        case .good: return Color.blue
        case .fail: return GameColors.fail
        }
    }
}