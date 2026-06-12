import SwiftUI
import SwiftData

struct AddRecipeView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var name: String
    @State private var calcium: String
    @State private var magnesium: String
    @State private var potassium: String
    @State private var sodium: String

    init(prefill: AddRecipeParams?) {
        _name = State(initialValue: prefill?.name ?? "")
        _calcium = State(initialValue: prefill.map { String($0.calcium) } ?? "")
        _magnesium = State(initialValue: prefill.map { String($0.magnesium) } ?? "")
        _potassium = State(initialValue: prefill.map { String($0.potassium) } ?? "")
        _sodium = State(initialValue: prefill.map { String($0.sodium) } ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Name") {
                    TextField("e.g. My Espresso Blend", text: $name)
                        .accessibilityIdentifier("addRecipe.name")
                }
                Section {
                    LabeledContent("Calcium (ppm)") {
                        TextField("0", text: $calcium)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .accessibilityIdentifier("addRecipe.calcium")
                    }
                    LabeledContent("Magnesium (ppm)") {
                        TextField("0", text: $magnesium)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .accessibilityIdentifier("addRecipe.magnesium")
                    }
                    LabeledContent("Potassium (ppm)") {
                        TextField("0", text: $potassium)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .accessibilityIdentifier("addRecipe.potassium")
                    }
                    LabeledContent("Sodium (ppm)") {
                        TextField("0", text: $sodium)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .accessibilityIdentifier("addRecipe.sodium")
                    }
                } header: {
                    Text("Minerals")
                } footer: {
                    Text("Enter concentrations in ppm as CaCO₃.General Hardness (GH) = Magnesium + Calcium. Alkalinity (KH) = Potassium + Sodium. The app will calculate how many Lotus dropper drops to use for your chosen brew volume.")
                }
            }
            .navigationTitle("New Recipe")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .accessibilityIdentifier("addRecipe.cancel")
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveRecipe() }
                        .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                        .accessibilityIdentifier("addRecipe.save")
                }
            }
        }
    }

    /// Inserts a new ``Recipe`` into the model context from the form fields and dismisses the
    /// view. The name is trimmed of surrounding whitespace and each mineral string is parsed as
    /// a `Double`, defaulting to `0` when empty or invalid.
    private func saveRecipe() {
        let recipe = Recipe(
            name: name.trimmingCharacters(in: .whitespaces),
            magnesium: Double(magnesium) ?? 0,
            calcium: Double(calcium) ?? 0,
            potassium: Double(potassium) ?? 0,
            sodium: Double(sodium) ?? 0
        )
        modelContext.insert(recipe)
        dismiss()
    }
}
