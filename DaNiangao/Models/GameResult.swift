import Foundation

enum Rating: String, CaseIterable {
    case perfect = "完美!"
    case great = "很棒!"
    case good = "不错"
    case fail = "失败"

    var color: String {
        switch self {
        case .perfect: return "PerfectColor"
        case .great: return "GreatColor"
        case .good: return "GoodColor"
        case .fail: return "FailColor"
        }
    }

    var emoji: String {
        switch self {
        case .perfect: return "⭐️"
        case .great: return "🌟"
        case .good: return "✨"
        case .fail: return "💫"
        }
    }

    static func fromHitsAndMisses(hits: Int, misses: Int, requiredHits: Int) -> Rating {
        if hits >= requiredHits && misses == 0 {
            return .perfect
        } else if hits >= requiredHits {
            return .great
        } else if hits >= requiredHits / 2 {
            return .good
        } else {
            return .fail
        }
    }
}

struct GameResult: Identifiable, Equatable {
    let id = UUID()
    let level: Int
    let score: Int
    let hits: Int
    let misses: Int
    let targetScore: Int
    let rating: Rating
    let nextLevelUnlocked: Bool
    let isSuccess: Bool
    let coinsEarned: Int

    init(level: Int, score: Int, hits: Int, misses: Int, targetScore: Int, coinsEarned: Int = 0) {
        self.level = level
        self.score = score
        self.hits = hits
        self.misses = misses
        self.targetScore = targetScore
        self.isSuccess = score >= targetScore
        self.rating = Rating.fromHitsAndMisses(hits: hits, misses: misses, requiredHits: targetScore / 100)
        self.nextLevelUnlocked = score >= targetScore && level < 20
        self.coinsEarned = coinsEarned
    }
}