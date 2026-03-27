import SwiftUI

enum GameColors {
    static let primary = Color(hex: "F5A623")
    static let secondary = Color(hex: "E8D5B7")
    static let accent = Color(hex: "FF6B6B")
    static let success = Color(hex: "4ECDC4")
    static let fail = Color(hex: "FF8585")
    static let background = Color(hex: "FFF8E7")
    static let text = Color(hex: "4A4A4A")
    static let pathGradientStart = Color(hex: "D2A97A")
    static let pathGradientEnd = Color(hex: "A67C52")
    static let doughColor = Color(hex: "FFF9E6")
    static let moistSuccess = Color(hex: "FFB6C1")
    static let coinGold = Color(hex: "FFD700")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

enum GameConstants {
    static let perfectZoneStart: Double = 0.85
    static let perfectZoneEnd: Double = 0.95
    static let goodZoneStart: Double = 0.75
    static let goodZoneEnd: Double = 0.85
    static let pathWidth: Double = 0.75
    static let doughSize: CGFloat = 60
    static let maxAttempts: Int = 3
    static let perfectScore: Int = 100
    static let goodScore: Int = 50
    static let coinsPerGame: Int = 30
}

enum GameFonts {
    static let title = Font.system(size: 48, weight: .bold, design: .rounded)
    static let subtitle = Font.system(size: 28, weight: .semibold, design: .rounded)
    static let body = Font.system(size: 20, weight: .medium, design: .rounded)
    static let caption = Font.system(size: 16, weight: .regular, design: .rounded)
    static let score = Font.system(size: 36, weight: .bold, design: .monospaced)
}

enum MochiPattern: String, CaseIterable, Codable, Identifiable {
    case swirl = "swirl"
    case zigzag = "zigzag"
    case dots = "dots"
    case waves = "waves"
    case spiral = "spiral"
    case burst = "burst"

    var id: String { rawValue }
}

enum MochiSkinColor: String, CaseIterable, Codable, Identifiable {
    case classic = "classic"
    case sunset = "sunset"
    case ocean = "ocean"
    case forest = "forest"
    case lavender = "lavender"
    case coral = "coral"
    case mint = "mint"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .classic: return "经典白"
        case .sunset: return "落日红"
        case .ocean: return "海洋蓝"
        case .forest: return "森林绿"
        case .lavender: return "薰衣草紫"
        case .coral: return "珊瑚粉"
        case .mint: return "薄荷绿"
        }
    }

    var price: Int {
        switch self {
        case .classic: return 0
        case .sunset: return 500
        case .ocean: return 300
        case .forest: return 250
        case .lavender: return 350
        case .coral: return 400
        case .mint: return 200
        }
    }

    var gradientColors: [Color] {
        switch self {
        case .classic:
            return [Color(hex: "FFFFFF"), Color(hex: "FFF9E6"), Color(hex: "F5ECD7")]
        case .sunset:
            return [Color(hex: "FF6B6B"), Color(hex: "FF8E53"), Color(hex: "FFB347")]
        case .ocean:
            return [Color(hex: "667EEA"), Color(hex: "764BA2"), Color(hex: "6B8DD6")]
        case .forest:
            return [Color(hex: "11998E"), Color(hex: "38EF7D"), Color(hex: "7FD36E")]
        case .lavender:
            return [Color(hex: "E0C3FC"), Color(hex: "8EC5FC"), Color(hex: "C9A7EB")]
        case .coral:
            return [Color(hex: "FFB6C1"), Color(hex: "FF69B4"), Color(hex: "FF85A2")]
        case .mint:
            return [Color(hex: "A8EDEA"), Color(hex: "5DDCD3"), Color(hex: "7FDBDA")]
        }
    }

    var patternColor: Color {
        switch self {
        case .classic: return Color(hex: "E8D5B7")
        case .sunset: return Color(hex: "FFE4B5")
        case .ocean: return Color(hex: "B0C4DE")
        case .forest: return Color(hex: "98FB98")
        case .lavender: return Color(hex: "DDA0DD")
        case .coral: return Color(hex: "FFDAB9")
        case .mint: return Color(hex: "98FF98")
        }
    }

    var isDefault: Bool {
        self == .classic
    }
}