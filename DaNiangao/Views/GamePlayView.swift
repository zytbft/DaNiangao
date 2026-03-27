import SwiftUI

struct GamePlayView: View {
    @ObservedObject var viewModel: GameViewModel
    let onGameEnd: (GameResult) -> Void
    let onOpenSettings: () -> Void

    @State private var showHitEffect = false
    @State private var hitEffectPosition: CGPoint = .zero
    @State private var hitEffectType: HitEffectType = .perfect

    enum HitEffectType {
        case perfect, good, miss
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                GameColors.background
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    topBar
                        .padding(.horizontal, 30)
                        .padding(.top, 20)

                    Spacer()

                    gameArea(size: geometry.size)

                    Spacer()

                    bottomBar
                        .padding(.horizontal, 30)
                        .padding(.bottom, 30)
                }
            }
            .onTapGesture {
                if viewModel.canHit {
                    performHit()
                }
            }
            .onKeyPress(.space) {
                if viewModel.canHit {
                    performHit()
                }
                return .handled
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var topBar: some View {
        HStack {
            Button(action: onOpenSettings) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(GameColors.text.opacity(0.6))
            }
            .buttonStyle(.plain)

            Text("关卡 \(viewModel.gameState.currentLevelNumber)")
                .font(GameFonts.body)
                .foregroundStyle(GameColors.text)
                .padding(.leading, 15)

            Spacer()

            HStack(spacing: 5) {
                Image(systemName: "star.fill")
                    .foregroundStyle(GameColors.coinGold)
                Text("\(viewModel.totalCoins)")
                    .font(GameFonts.body)
                    .foregroundStyle(GameColors.coinGold)
            }

            Spacer()

            Text("得分: \(viewModel.gameState.score)")
                .font(GameFonts.score)
                .foregroundStyle(GameColors.primary)

            Spacer()

            if let level = viewModel.currentLevel {
                Text("目标: \(level.targetScore)")
                    .font(GameFonts.caption)
                    .foregroundStyle(GameColors.text.opacity(0.6))
            }
        }
    }

    private func gameArea(size: CGSize) -> some View {
        let pathWidth = size.width * GameConstants.pathWidth
        let pathHeight: CGFloat = 100

        return ZStack {
            GamePathView(pathWidth: pathWidth, pathHeight: pathHeight)
                .frame(width: pathWidth, height: pathHeight)

            MochiDoughView(
                position: viewModel.gameState.doughPosition,
                pathWidth: pathWidth,
                isAnimating: viewModel.gameState.phase == .hitting,
                pattern: viewModel.currentPattern,
                skinColor: viewModel.selectedSkin
            )
            .offset(x: -pathWidth/2 + viewModel.gameState.doughPosition * pathWidth)

            HammerView(isHitting: viewModel.gameState.phase == .hitting)
                .offset(y: -60)

            successZoneIndicator
                .offset(x: pathWidth/2 - 40)

            if case .ready = viewModel.gameState.phase {
                countdownView
            }

            if case .levelComplete = viewModel.gameState.phase {
                levelCompleteOverlay
            }

            if case .gameOver = viewModel.gameState.phase {
                gameOverOverlay
            }
        }
        .frame(width: size.width, height: 200)
    }

    private var successZoneIndicator: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(GameColors.moistSuccess.opacity(0.5))
                .frame(width: 60, height: 80)

            Text("目标")
                .font(GameFonts.caption)
                .foregroundStyle(GameColors.success)
        }
    }

    private var countdownView: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            Text("\(viewModel.gameState.countdown)")
                .font(.system(size: 120, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .scaleEffect(viewModel.gameState.countdown > 0 ? 1.0 : 0.5)
                .animation(.easeOut(duration: 0.3), value: viewModel.gameState.countdown)
        }
    }

    private var levelCompleteOverlay: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture { }

            VStack(spacing: 20) {
                Text("🎉")
                    .font(.system(size: 60))

                Text("关卡完成!")
                    .font(GameFonts.title)
                    .foregroundStyle(.white)

                HStack(spacing: 30) {
                    VStack {
                        Text("得分")
                            .font(GameFonts.caption)
                            .foregroundStyle(.white.opacity(0.7))
                        Text("\(viewModel.gameState.score)")
                            .font(GameFonts.score)
                            .foregroundStyle(GameColors.success)
                    }

                    VStack {
                        Text("金币")
                            .font(GameFonts.caption)
                            .foregroundStyle(.white.opacity(0.7))
                        HStack(spacing: 5) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(GameColors.coinGold)
                            Text("+\(GameConstants.coinsPerGame)")
                                .font(GameFonts.score)
                                .foregroundStyle(GameColors.coinGold)
                        }
                    }
                }

                Text("命中: \(viewModel.gameState.hits) / \(viewModel.currentLevel?.requiredHits ?? 0)")
                    .font(GameFonts.body)
                    .foregroundStyle(.white.opacity(0.8))

                HStack(spacing: 20) {
                    Button("返回菜单") {
                        if let result = viewModel.createResult() {
                            onGameEnd(result)
                        }
                    }
                    .buttonStyle(LevelCompleteButtonStyle(color: .gray))

                    Button("下一关") {
                        if let result = viewModel.createResult() {
                            onGameEnd(result)
                        }
                    }
                    .buttonStyle(LevelCompleteButtonStyle(color: GameColors.success))
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.8))
            )
        }
    }

    private var gameOverOverlay: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture { }

            VStack(spacing: 20) {
                Text("💔")
                    .font(.system(size: 60))

                Text("挑战失败")
                    .font(GameFonts.title)
                    .foregroundStyle(.white)

                HStack(spacing: 30) {
                    VStack {
                        Text("得分")
                            .font(GameFonts.caption)
                            .foregroundStyle(.white.opacity(0.7))
                        Text("\(viewModel.gameState.score)")
                            .font(GameFonts.score)
                            .foregroundStyle(GameColors.fail)
                    }

                    VStack {
                        Text("金币")
                            .font(GameFonts.caption)
                            .foregroundStyle(.white.opacity(0.7))
                        HStack(spacing: 5) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(GameColors.coinGold)
                            Text("+\(GameConstants.coinsPerGame / 2)")
                                .font(GameFonts.score)
                                .foregroundStyle(GameColors.coinGold)
                        }
                    }
                }

                Text("命中: \(viewModel.gameState.hits) / \(viewModel.currentLevel?.requiredHits ?? 0)")
                    .font(GameFonts.body)
                    .foregroundStyle(.white.opacity(0.8))

                HStack(spacing: 20) {
                    Button("返回菜单") {
                        if let result = viewModel.createResult() {
                            onGameEnd(result)
                        }
                    }
                    .buttonStyle(LevelCompleteButtonStyle(color: .gray))

                    Button("重试") {
                        if let level = viewModel.currentLevel {
                            viewModel.startLevel(level)
                        }
                    }
                    .buttonStyle(LevelCompleteButtonStyle(color: GameColors.primary))
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.black.opacity(0.8))
            )
        }
    }

    private var bottomBar: some View {
        HStack {
            Text("剩余次数:")
                .font(GameFonts.body)
                .foregroundStyle(GameColors.text)

            HStack(spacing: 8) {
                ForEach(0..<GameConstants.maxAttempts, id: \.self) { index in
                    Circle()
                        .fill(index < viewModel.gameState.attemptsLeft ? GameColors.accent : Color.gray.opacity(0.3))
                        .frame(width: 20, height: 20)
                }
            }

            Spacer()

            Text("按 空格键 或 点击屏幕 打击!")
                .font(GameFonts.caption)
                .foregroundStyle(GameColors.text.opacity(0.5))
        }
    }

    private func performHit() {
        hitEffectType = determineHitType()
        viewModel.hit()
    }

    private func determineHitType() -> HitEffectType {
        let pos = viewModel.gameState.doughPosition
        if pos >= GameConstants.perfectZoneStart && pos <= GameConstants.perfectZoneEnd {
            return .perfect
        } else if pos >= GameConstants.goodZoneStart {
            return .good
        }
        return .miss
    }
}

struct LevelCompleteButtonStyle: ButtonStyle {
    let color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(GameFonts.body)
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(color)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}