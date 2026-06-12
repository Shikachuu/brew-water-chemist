import SwiftUI

/// Keeps the screen awake and at full brightness while the modified view is on
/// screen, restoring the previous brightness and idle-timer state on disappear.
private struct KeepScreenAwakeModifier: ViewModifier {
    @State private var previousBrightness: CGFloat?

    func body(content: Content) -> some View {
        content
            .onAppear { keepScreenAwake() }
            .onDisappear { restoreScreenState() }
    }

    /// The screen backing the active window scene, found through context rather
    /// than the deprecated `UIScreen.main`.
    private var screen: UIScreen? {
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        return scenes.first(where: { $0.activationState == .foregroundActive })?.screen
            ?? scenes.first?.screen
    }

    private func keepScreenAwake() {
        UIApplication.shared.isIdleTimerDisabled = true
        guard let screen else { return }
        if previousBrightness == nil {
            previousBrightness = screen.brightness
        }
        screen.brightness = 1.0
    }

    private func restoreScreenState() {
        UIApplication.shared.isIdleTimerDisabled = false
        if let previousBrightness, let screen {
            screen.brightness = previousBrightness
        }
        previousBrightness = nil
    }
}

extension View {
    /// Prevents the device from sleeping and raises brightness to 100% while
    /// this view is visible, restoring both when it disappears.
    func keepScreenAwake() -> some View {
        modifier(KeepScreenAwakeModifier())
    }
}
