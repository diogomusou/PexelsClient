import API
import Dependencies
import Models
import SwiftUI

@Observable
public class PhotoFullscreenViewModel: ObservableObject {
    var image: UIImage?
    var error: String?
    var photo: PexelsPhoto
    var thumbnailImage: Image?

    private var onDismiss: () -> Void

    @ObservationIgnored
    @Dependency(APIClient.self) private var api
    @ObservationIgnored
    @Dependency(\.continuousClock) private var clock

    public init(
        photo: PexelsPhoto,
        thumbnailImage: Image? = nil,
        onDismiss: @escaping () -> Void
    ) {
        self.photo = photo
        self.thumbnailImage = thumbnailImage
        self.onDismiss = onDismiss

        Task {
            await loadImage()
        }
    }

    func didTapDismiss() {
        onDismiss()
    }

    private func loadImage() async {
        guard let url = URL(string: photo.src.original) else {
            error = "Invalid URL"
            return
        }

        do {
            try? await clock.sleep(for: .seconds(0.2))
            let data = try await api.fetchData(from: url)
            if let image = UIImage(data: data) {
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
