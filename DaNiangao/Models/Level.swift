import Foundation

struct Level: Identifiable, Codable, Equatable {
    let id: Int
    let speed: Double
    let targetScore: Int
    let requiredHits: Int
    var isUnlocked: Bool

    static func generateLevels() -> [Level] {
        var levels: [Level] = []
        let baseSpeed = 80.0
        let levelConfigs: [(Int, Int, Int)] = [
            (1, 200, 2), (2, 300, 3), (3, 400, 4), (4, 500, 5), (5, 600, 6),
            (6, 750, 8), (7, 900, 9), (8, 1050, 11), (9, 1200, 12), (10, 1400, 14),
            (11, 1600, 16), (12, 1800, 18), (13, 2000, 20), (14, 2200, 22),
            (15, 2500, 25), (16, 2800, 28), (17, 3100, 31), (18, 3500, 35),
            (19, 3900, 39), (20, 4500, 45)
        ]

        for (index, config) in levelConfigs.enumerated() {
            let levelNum = index + 1
            let speed = baseSpeed + Double(levelNum) * 5 + Double(levelNum - 1) * 5
            let level = Level(
                id: levelNum,
                speed: speed,
                targetScore: config.1,
                requiredHits: config.2,
                isUnlocked: levelNum == 1
            )
            levels.append(level)
        }
        return levels
    }
}