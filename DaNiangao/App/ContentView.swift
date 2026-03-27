import SwiftUI

struct ContentView: View {
    @StateObject private var gameViewModel = GameViewModel()
    @State private var currentScreen: Screen = .menu

    enum Screen {
        case menu
        case levelSelect
        case game
        case result
        case skinShop
        case settings
    }

    var body: some View {
        ZStack {
            GameColors.background
                .ignoresSafeArea()

            switch currentScreen {
            case .menu:
                MainMenuView(
                    onStartGame: {
                        currentScreen = .levelSelect
                    },
                    onOpenShop: {
                        currentScreen = .skinShop
                    },
                    onOpenSettings: {
                        currentScreen = .settings
                    },
                    totalCoins: gameViewModel.totalCoins
                )
            case .levelSelect:
                LevelSelectView(
                    viewModel: gameViewModel,
                    onSelectLevel: { level in
                        gameViewModel.startLevel(level)
                        currentScreen = .game
                    },
                    onBack: {
                        currentScreen = .menu
                    },
                    onOpenShop: {
                        currentScreen = .skinShop
                    },
                    onOpenSettings: {
                        currentScreen = .settings
                    },
                    totalCoins: gameViewModel.totalCoins
                )
            case .game:
                GamePlayView(viewModel: gameViewModel, onGameEnd: { result in
                    gameViewModel.saveResult(result)
                    currentScreen = .result
                }, onOpenSettings: {
                    currentScreen = .settings
                })
            case .result:
                ResultView(viewModel: gameViewModel, onReplay: {
                    if let level = gameViewModel.currentLevel {
                        gameViewModel.startLevel(level)
                        currentScreen = .game
                    }
                }, onNextLevel: {
                    if let nextLevel = gameViewModel.getNextLevel() {
                        gameViewModel.startLevel(nextLevel)
                        currentScreen = .game
                    } else {
                        currentScreen = .levelSelect
                    }
                }, onBackToMenu: {
                    currentScreen = .levelSelect
                })
            case .skinShop:
                SkinShopView(viewModel: gameViewModel, onBack: {
                    currentScreen = .menu
                })
            case .settings:
                SettingsView(viewModel: gameViewModel, onBack: {
                    currentScreen = .menu
                }, onOpenShop: {
                    currentScreen = .skinShop
                })
            }
        }
        .frame(minWidth: 800, minHeight: 600)
    }
}