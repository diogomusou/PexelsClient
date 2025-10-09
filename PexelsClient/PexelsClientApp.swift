import API
import PhotosListFeature
import SwiftUI

@main
struct PexelsClientApp: App {
    var body: some Scene {
        WindowGroup {
            PhotosListView(viewModel: .init(api: .live))
        }
    }
}
