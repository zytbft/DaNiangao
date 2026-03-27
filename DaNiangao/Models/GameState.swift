import Foundation

enum GamePhase: Equatable {
    case ready
    case playing
    case hitting
    case showingResult
    case levelComplete
    case gameOver
}

struct GameState: Equatable {
    var phase: GamePhase = .ready
    var currentLevelNumber: Int = 1
    var score: Int = 0
    var hits: Int = 0
    var misses: Int = 0
    var doughPosition: Double = 0.0
    var attemptsLeft: Int = 3
    var countdown: Int = 3

    var remainingAttempts: Int {
        max(0, attemptsLeft)
    }
}