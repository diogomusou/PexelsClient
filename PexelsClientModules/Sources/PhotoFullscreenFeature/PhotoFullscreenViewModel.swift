import API
import SwiftUI

@MainActor
public class PhotoFullscreenViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var error: String?
    @Published var photo: PexelsPhoto
    @Published var placeholder: Image?

    public init(photo: PexelsPhoto, placeholder: Image? = nil) {
        self.photo = photo
        self.placeholder = placeholder

        Task {
            await loadImage()
        }
    }

    private func loadImage() async {
        guard let url = URL(string: photo.src.original) else {
            error = "Invalid URL"
            return
        }

        do {
            try? await Task.sleep(nanoseconds: 200_000_000)
            let data = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data.0) {
                self.image = image
                error = nil
            } else {
                error = "No image"
            }
        } catch {
            self.error = error.localizedDescription
        }
    }
}
