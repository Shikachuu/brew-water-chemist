import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.editMode) private var editMode
    @Query private var settingsArray: [AppSettings]
    @State private var viewModel = SettingsViewModel()

    private var settings: AppSettings? { settingsArray.first }

    var body: some View {
        List {
            if let settings {
                Section("Water Quantities") {
                    ForEach(settings.quantities, id: \.self) { qty in
                        Text(formattedQuantity(qty))
                    }
                    .onMove { indices, newOffset in
                        settings.quantities.move(fromOffsets: indices, toOffset: newOffset)
                    }
                    .onDelete { indices in
                        settings.quantities.remove(atOffsets: indices)
                    }
                    Button {
                        viewModel.showAddQuantity = true
                    } label: {
                        Label("Add Quantity", systemImage: "plus")
                    }
                }

                Section("Default Mineral Kit") {
                    Picker("Mineral Kit", selection: Binding(
                        get: { settings.mineralKit },
                        set: { settings.mineralKit = $0 }
                    )) {
                        Text(MineralKit.lotusRound.displayName).tag(MineralKit.lotusRound)
                        Text(MineralKit.lotusStraight.displayName).tag(MineralKit.lotusStraight)
                    }
                    .pickerStyle(.menu)
                }

                Section("Recipes") {
                    Button(role: .destructive) {
                        viewModel.showResetConfirmation = true
                    } label: {
                        Text("Reset to Defaults")
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .toolbar {
            EditButton()
        }
        .sheet(isPresented: $viewModel.showAddQuantity) {
            AddQuantitySheet { qty in
                settings?.quantities.append(qty)
            }
        }
        .confirmationDialog(
            "Reset Recipes",
            isPresented: $viewModel.showResetConfirmation,
            titleVisibility: .visible
        ) {
            Button("Reset", role: .destructive) { resetToDefaults() }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will replace all recipes with the original defaults. This cannot be undone.")
        }
    }

    private func formattedQuantity(_ milliliters: Int) -> String {
        milliliters >= 1000 ? "\(milliliters / 1000)L (\(milliliters) mL)" : "\(milliliters) mL"
    }

    private func resetToDefaults() {
        guard let settings else { return }
        settings.quantities = [500, 1000, 2000, 3000, 4500, 10000]
        settings.mineralKit = .lotusRound
    }
}

struct AddQuantitySheet: View {
    @Environment(\.dismiss) private var dismiss
    let onAdd: (Int) -> Void
    @State private var text = ""

    private var parsedValue: Int? { Int(text).flatMap { $0 > 0 ? $0 : nil } }

    var body: some View {
        NavigationStack {
            Form {
                Section("Volume (mL)") {
                    TextField("Enter mL (e.g. 750)", text: $text)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Add Quantity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        if let value = parsedValue {
                            onAdd(value)
                            dismiss()
                        }
                    }
                    .disabled(parsedValue == nil)
                }
            }
        }
        .presentationDetents([.medium])
    }
}
