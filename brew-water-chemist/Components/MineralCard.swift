import SwiftUI

struct MineralCard: View {
    let label: String
    let value: Int
    let unit: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Spacer()
            Text(label)
                .font(.subheadline)
                .fontWeight(.medium)
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(value)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .accessibilityIdentifier("mineral.\(label.lowercased()).value")
                Text(unit)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .opacity(0.7)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding()
        .glassEffect(in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .fill(color.opacity(0.55))
                .allowsHitTesting(false)
        )
    }
}
