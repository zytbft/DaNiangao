import Foundation
import Combine

class GameViewModel: ObservableObject {
    @Published var gameState = GameState()
    @Published var levels: [Level] = Level.generateLevels()
    @Published var lastResult: GameResult?
    @Published var currentPattern: MochiPattern = .swirl
    @Published var selectedSkin: MochiSkinColor = .classic
    @Published var totalCoins: Int = 0

    private let userData = UserDataManager.shared
    private var gameTimer: AnyCancellable?
    private var doughMovementTimer: AnyCancellable?
    private var countdownTimer: AnyCancellable?
    private var cancellables = Set<AnyCancellable>()

    var currentLevel: Level? {
        guard gameState.currentLevelNumber >= 1 && gameState.currentLevelNumber <= levels.count else {
            return nil
        }
        return levels[gameState.currentLevelNumber - 1]
    }

    var isPlaying: Bool {
        gameState.phase == .playing
    }

    var canHit: Bool {
        gameState.phase == .playing
    }

    init() {
        syncFromUserData()
        setupBindings()
        syncUnlockedLevels()
        generateNewPattern()
    }

    private func setupBindings() {
        userData.$selectedSkin
            .receive(on: DispatchQueue.main)
            .sink { [weak self] skin in
                self?.selectedSkin = skin
            }
            .store(in: &cancellables)

        userData.$coins
            .receive(on: DispatchQueue.main)
            .sink { [weak self] coins in
                self?.totalCoins = coins
            }
            .store(in: &cancellables)

        userData.$ownedSkins
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    private func syncFromUserData() {
        selectedSkin = userData.selectedSkin
        totalCoins = userData.coins
    }

    private func syncUnlockedLevels() {
        for i in 0..<levels.count {
            levels[i].isUnlocked = userData.isLevelUnlocked(i + 1)
        }
    }

    func startLevel(_ level: Level) {
        gameState = GameState()
        gameState.currentLevelNumber = level.id
        gameState.phase = .ready
        gameState.countdown = 3
        gameState.attemptsLeft = GameConstants.maxAttempts
        generateNewPattern()
        startCountdown()
    }

    private func generateNewPattern() {
        currentPattern = MochiPattern.allCases.randomElement() ?? .swirl
    }

    private func startCountdown() {
        countdownTimer?.cancel()
        countdownTimer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                self.gameState.countdown -= 1

                if self.gameState.countdown <= 0 {
                    self.countdownTimer?.cancel()
                    self.startPlaying()
                }
            }
    }

    private func startPlaying() {
        gameState.phase = .playing
        gameState.doughPosition = 0.0
        startDoughMovement()
    }

    private func startDoughMovement() {
        doughMovementTimer?.cancel()

        guard let level = currentLevel else { return }

        let pixelsPerFrame = level.speed / 60.0
        let pathLength: Double = 500

        doughMovementTimer = Timer.publish(every: 1.0 / 60.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }

                guard self.gameState.phase == .playing else {
                    self.doughMovementTimer?.cancel()
                    return
                }

                self.gameState.doughPosition += pixelsPerFrame / pathLength

                if self.gameState.doughPosition >= 1.0 {
                    self.doughMovementTimer?.cancel()
                    self.handleMiss()
                }
            }
    }

    func hit() {
        guard gameState.phase == .playing else { return }

        doughMovementTimer?.cancel()
        gameState.phase = .hitting

        let position = gameState.doughPosition

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }

            if position >= GameConstants.perfectZoneStart && position <= GameConstants.perfectZoneEnd {
                self.handlePerfectHit()
            } else if position >= GameConstants.goodZoneStart && position < GameConstants.perfectZoneStart {
                self.handleGoodHit()
            } else {
                self.handleMiss()
            }
        }
    }

    private func handlePerfectHit() {
        gameState.score += GameConstants.perfectScore
        gameState.hits += 1
        generateNewPattern()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.checkLevelProgress()
        }
    }

    private func handleGoodHit() {
        gameState.score += GameConstants.goodScore
        gameState.hits += 1
        generateNewPattern()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.checkLevelProgress()
        }
    }

    private func handleMiss() {
        gameState.misses += 1
        gameState.attemptsLeft -= 1
        generateNewPattern()

        if gameState.attemptsLeft <= 0 {
            endGame()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.gameState.phase = .playing
                self?.gameState.doughPosition = 0.0
                self?.startDoughMovement()
            }
        }
    }

    private func checkLevelProgress() {
        guard let level = currentLevel else { return }

        if gameState.score >= level.targetScore {
            endLevel(success: true)
        } else if gameState.hits >= level.requiredHits {
            if gameState.score >= level.targetScore {
                endLevel(success: true)
            } else {
                gameState.phase = .playing
                gameState.doughPosition = 0.0
                startDoughMovement()
            }
        } else {
            gameState.phase = .playing
            gameState.doughPosition = 0.0
            startDoughMovement()
        }
    }

    private func endLevel(success: Bool) {
        doughMovementTimer?.cancel()
        countdownTimer?.cancel()

        if success {
            gameState.phase = .levelComplete
            userData.unlockNextLevel(after: gameState.currentLevelNumber)
            userData.setHighScore(for: gameState.currentLevelNumber, score: gameState.score)
            userData.addCoins(GameConstants.coinsPerGame)
            syncUnlockedLevels()
        } else {
            endGame()
        }
    }

    private func endGame() {
        doughMovementTimer?.cancel()
        countdownTimer?.cancel()
        gameState.phase = .gameOver
    }

    func saveResult(_ result: GameResult) {
        lastResult = result
        if result.isSuccess {
            userData.unlockNextLevel(after: result.level)
            syncUnlockedLevels()
        }
    }

    func createResult() -> GameResult? {
        guard let level = currentLevel else { return nil }

        return GameResult(
            level: gameState.currentLevelNumber,
            score: gameState.score,
            hits: gameState.hits,
            misses: gameState.misses,
            targetScore: level.targetScore,
            coinsEarned: gameState.phase == .levelComplete ? GameConstants.coinsPerGame : 0
        )
    }

    func getNextLevel() -> Level? {
        let nextLevelNum = gameState.currentLevelNumber + 1
        guard nextLevelNum <= levels.count else { return nil }
        return levels[nextLevelNum - 1]
    }

    func resetToMenu() {
        doughMovementTimer?.cancel()
        countdownTimer?.cancel()
        gameState = GameState()
    }

    func isLevelUnlocked(_ level: Int) -> Bool {
        return userData.isLevelUnlocked(level)
    }

    func getHighScore(for level: Int) -> Int {
        return userData.getHighScore(for: level)
    }

    func purchaseSkin(_ skin: MochiSkinColor) -> Bool {
        return userData.purchaseSkin(skin)
    }

    func selectSkin(_ skin: MochiSkinColor) {
        userData.selectSkin(skin)
    }

    func isSkinOwned(_ skin: MochiSkinColor) -> Bool {
        return userData.isSkinOwned(skin)
    }

    func getOwnedSkins() -> [MochiSkinColor] {
        return userData.ownedSkins
    }

    deinit {
        doughMovementTimer?.cancel()
        countdownTimer?.cancel()
    }
}