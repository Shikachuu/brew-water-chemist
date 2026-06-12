import SwiftUI

struct VolumeSelector: View {
    let quantities: [Int]
    @Binding var selectedVolume: Int

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            GlassEffectContainer {
                HStack(spacing: 8) {
                    ForEach(quantities, id: \.self) { volume in
                        Button {
                            selectedVolume = volume
                        } label: {
                            Text(formatted(volume))
                                .font(.subheadline)
                                .fontWeight(selectedVolume == volume ? .semibold : .regular)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .foregroundStyle(selectedVolume == volume ? .primary : .secondary)
                        }
                        .accessibilityIdentifier("volume.\(volume)")
                        .glassEffect(.regular.interactive(), in: Capsule())
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private func formatted(_ milliliters: Int) -> String {
        if milliliters >= 1000 {
            let liters = Double(milliliters) / 1000.0
            return liters.truncatingRemainder(dividingBy: 1) == 0
                ? "\(Int(liters))L"
                : String(format: "%.1fL", liters)
        }
        return "\(milliliters)mL"
    }
}
