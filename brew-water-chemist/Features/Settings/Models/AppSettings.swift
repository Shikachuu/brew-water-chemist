import Foundation
import SwiftData

enum MineralKit: String, Codable {
    case lotusRound
    case lotusStraight

    var displayName: String {
        switch self {
        case .lotusRound: "Lotus (new, round)"
        case .lotusStraight: "Lotus (old, straight)"
        }
    }
}

@Model final class AppSettings {
    var quantities: [Int]
    var mineralKit: MineralKit

    init(quantities: [Int] = [500, 1000, 2000, 3000, 4500, 10000], mineralKit: MineralKit = .lotusRound) {
        self.quantities = quantities
        self.mineralKit = mineralKit
    }

    static var `default`: AppSettings { AppSettings() }
}
