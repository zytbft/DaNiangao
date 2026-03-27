import Foundation
import Combine

class UserDataManager: ObservableObject {
    static let shared = UserDataManager()

    private let unlockedLevelsKey = "unlockedLevels"
    private let highScoresKey = "highScores"
    private let soundEnabledKey = "soundEnabled"
    private let coinsKey = "userCoins"
    private let ownedSkinsKey = "ownedSkins"
    private let selectedSkinKey = "selectedSkin"

    @Published var unlockedLevels: Int = 1 {
        didSet {
            UserDefaults.standard.set(unlockedLevels, forKey: unlockedLevelsKey)
        }
    }

    @Published var soundEnabled: Bool = true {
        didSet {
            UserDefaults.standard.set(soundEnabled, forKey: soundEnabledKey)
        }
    }

    @Published var highScores: [Int: Int] = [:] {
        didSet {
            if let data = try? JSONEncoder().encode(highScores) {
                UserDefaults.standard.set(data, forKey: highScoresKey)
            }
        }
    }

    @Published var coins: Int = 0 {
        didSet {
            UserDefaults.standard.set(coins, forKey: coinsKey)
        }
    }

    @Published var ownedSkins: [MochiSkinColor] = [.classic] {
        didSet {
            if let data = try? JSONEncoder().encode(ownedSkins.map { $0.rawValue }) {
                UserDefaults.standard.set(data, forKey: ownedSkinsKey)
            }
        }
    }

    @Published var selectedSkin: MochiSkinColor = .classic {
        didSet {
            if let data = try? JSONEncoder().encode(selectedSkin.rawValue) {
                UserDefaults.standard.set(data, forKey: selectedSkinKey)
            }
        }
    }

    private init() {
        let stored = UserDefaults.standard.integer(forKey: unlockedLevelsKey)
        self.unlockedLevels = stored > 0 ? stored : 1

        if UserDefaults.standard.contains(key: soundEnabledKey) {
            self.soundEnabled = UserDefaults.standard.bool(forKey: soundEnabledKey)
        }

        if let data = UserDefaults.standard.data(forKey: highScoresKey),
           let scores = try? JSONDecoder().decode([Int: Int].self, from: data) {
            self.highScores = scores
        }

        self.coins = UserDefaults.standard.integer(forKey: coinsKey)

        if let skinsData = UserDefaults.standard.data(forKey: ownedSkinsKey),
           let skinStrings = try? JSONDecoder().decode([String].self, from: skinsData) {
            self.ownedSkins = skinStrings.compactMap { MochiSkinColor(rawValue: $0) }
            if self.ownedSkins.isEmpty {
                self.ownedSkins = [.classic]
            }
        }

        if let selectedSkinData = UserDefaults.standard.data(forKey: selectedSkinKey),
           let skinString = try? JSONDecoder().decode(String.self, from: selectedSkinData),
           let skin = MochiSkinColor(rawValue: skinString) {
            self.selectedSkin = skin
        }
    }

    func addCoins(_ amount: Int) {
        coins += amount
    }

    func spendCoins(_ amount: Int) -> Bool {
        guard coins >= amount else { return false }
        coins -= amount
        return true
    }

    func purchaseSkin(_ skin: MochiSkinColor) -> Bool {
        guard !ownedSkins.contains(skin) else { return false }
        guard skin.price > 0 else {
            ownedSkins.append(skin)
            return true
        }
        guard spendCoins(skin.price) else { return false }
        ownedSkins.append(skin)
        return true
    }

    func isSkinOwned(_ skin: MochiSkinColor) -> Bool {
        ownedSkins.contains(skin)
    }

    func selectSkin(_ skin: MochiSkinColor) {
        if ownedSkins.contains(skin) {
            selectedSkin = skin
        }
    }

    func getHighScore(for level: Int) -> Int {
        return highScores[level] ?? 0
    }

    func setHighScore(for level: Int, score: Int) {
        if score > (highScores[level] ?? 0) {
            highScores[level] = score
        }
    }

    func unlockNextLevel(after currentLevel: Int) {
        if currentLevel >= unlockedLevels && currentLevel < 20 {
            unlockedLevels = currentLevel + 1
        }
    }

    func isLevelUnlocked(_ level: Int) -> Bool {
        return level <= unlockedLevels
    }

    func resetProgress() {
        unlockedLevels = 1
        highScores = [:]
        coins = 0
        ownedSkins = [.classic]
        selectedSkin = .classic
    }
}

extension UserDefaults {
    func contains(key: String) -> Bool {
        return object(forKey: key) != nil
    }
}