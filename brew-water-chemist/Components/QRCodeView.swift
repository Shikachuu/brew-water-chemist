import SwiftUI
import CoreImage.CIFilterBuiltins

struct QRCodeView: View {
    let url: URL
    let size: CGFloat

    var body: some View {
        if let image = generateQRCode(from: url.absoluteString) {
            Image(uiImage: image)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .accessibilityIdentifier("share.qrCode")
        }
    }

    /// Renders the given string into a QR code image via Core Image.
    ///
    /// Uses medium ("M") error correction and scales the raw generator output 10× so the
    /// code stays crisp when displayed (paired with `.interpolation(.none)`).
    ///
    /// - Parameter string: The text to encode, typically a share URL.
    /// - Returns: The rendered QR image, or `nil` if generation failed.
    private func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(Data(string.utf8), forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")
        guard let ciImage = filter.outputImage else { return nil }
        let scaled = ciImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        guard let cgImage = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
