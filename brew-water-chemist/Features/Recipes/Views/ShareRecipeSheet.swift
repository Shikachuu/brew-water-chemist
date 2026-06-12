import SwiftUI

struct ShareRecipeSheet: View {
    let recipe: Recipe
    let shareURL: URL
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                QRCodeView(url: shareURL, size: 240)
                    .padding()
                    .glassEffect(in: RoundedRectangle(cornerRadius: 20))

                VStack(spacing: 8) {
                    Text(recipe.name)
                        .font(.headline)
                    Text("Scan to open in Brew Water Chemist")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }

                ShareLink(item: shareURL) {
                    Label("Share Link", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .glassEffect(.regular.interactive(), in: RoundedRectangle(cornerRadius: 16))

                Spacer()
            }
            .padding()
            .navigationTitle("Share Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("share.done")
                }
            }
        }
        .keepScreenAwake()
    }
}
