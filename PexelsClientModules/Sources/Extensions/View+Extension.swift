import SwiftUI

public extension View {
    @ViewBuilder func optionalGlassEffect() -> some View {
        if #available(iOS 26, *) {
            glassEffect(.clear.tint(.gray.opacity(0.3)))
        } else {
            self
        }
    }
}

public extension View {
    func asImage() -> Image {
        let renderer = ImageRenderer(content: self)
        guard let image = renderer.uiImage else { return Image(systemName: "xmark") }
        return Image(uiImage: image)
    }
}
