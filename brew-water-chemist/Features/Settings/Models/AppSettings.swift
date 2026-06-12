import Foundation
import SwiftData

/// A Lotus mineral dropper kit. The two variants differ in drop size, which affects dosing
/// in ``calculateDroplets(recipe:volumeMl:kit:)``.
enum MineralKit: String, Codable {
    case lotusRound
    case lotusStraight

    /// Human-readable kit name shown in the settings picker.
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

    /// A settings instance with the standard quantities and the round Lotus kit.
    static var `default`: AppSettings { AppSettings() }
}
