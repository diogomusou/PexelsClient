import API
import PhotoFullscreenFeature
import PhotosListFeature
import SwiftUI

@main
struct PexelsClientApp: App {
    var body: some Scene {
        WindowGroup {
            PhotosListView(viewModel: .init(api: .live))

            // To run the app straight into the PhotoFullscreenView, use this:
//            @Namespace var namespace
//            @State var isPresented = true
//            PhotoFullscreenView(viewModel: .init(photo: .dummyLandscape1), namespace: namespace, isPresented: $isPresented)
        }
    }
}
