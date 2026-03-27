import SwiftUI

struct LevelSelectView: View {
    @ObservedObject var viewModel: GameViewModel
    let onSelectLevel: (Level) -> Void
    let onBack: () -> Void
    let onOpenShop: () -> Void
    let onOpenSettings: () -> Void
    let totalCoins: Int

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.left")
                        Text("返回")
                    }
                    .font(GameFonts.caption)
                    .foregroundStyle(GameColors.text)
                }
                .buttonStyle(.plain)

                Spacer()

                Text("选择关卡")
                    .font(GameFonts.subtitle)
                    .foregroundStyle(GameColors.text)

                Spacer()

                HStack(spacing: 15) {
                    Button(action: onOpenSettings) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(GameColors.text.opacity(0.6))
                    }
                    .buttonStyle(.plain)

                    Button(action: onOpenShop) {
                        HStack(spacing: 5) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(GameColors.coinGold)
                            Text("\(totalCoins)")
                                .font(GameFonts.body)
                                .foregroundStyle(GameColors.coinGold)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.1), radius: 3)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 30)
            .padding(.top, 20)

            Text("已解锁: \(UserDataManager.shared.unlockedLevels)/20")
                .font(GameFonts.caption)
                .foregroundStyle(GameColors.primary)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(viewModel.levels) { level in
                        LevelButton(
                            level: level,
                            highScore: viewModel.getHighScore(for: level.id),
                            isUnlocked: viewModel.isLevelUnlocked(level.id)
                        ) {
                            onSelectLevel(level)
                        }
                    }
                }
                .padding(30)
            }

            Text("完美击中得100分，良好击中得50分")
                .font(GameFonts.caption)
                .foregroundStyle(GameColors.text.opacity(0.5))
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct LevelButton: View {
    let level: Level
    let highScore: Int
    let isUnlocked: Bool
    let action: () -> Void

    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(isUnlocked ? GameColors.primary : Color.gray.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .shadow(color: isUnlocked ? GameColors.primary.opacity(0.3) : .clear, radius: isHovered ? 10 : 5)

                    if isUnlocked {
                        Text("\(level.id)")
                            .font(GameFonts.subtitle)
                            .foregroundStyle(.white)
                    } else {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                }

                if isUnlocked {
                    Text("最高: \(highScore)")
                        .font(.system(size: 10))
                        .foregroundStyle(GameColors.text.opacity(0.6))
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(!isUnlocked)
        .scaleEffect(isHovered && isUnlocked ? 1.1 : 1.0)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}