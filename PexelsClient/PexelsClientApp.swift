import API
import APILive
import Dependencies
import PhotoFullscreenFeature
import PhotosListFeature
import SwiftUI

@main
struct PexelsClientApp: App {
    var body: some Scene {
        WindowGroup {
            withDependencies { dependencies in
                // Change the value below for stubs to avoid hitting the live API.
                // e.g: dependencies.api = .dummy
                dependencies.api = .liveValue
            } operation: {
                PhotosListView()
            }

            // To run the app straight into the PhotoFullscreenView, use this:

//            @Namespace var namespace
//            withDependencies { dependencies in
////                dependencies.api = .dummy
//            } operation: {
//                PhotoFullscreenView(viewModel: .init(photo: .dummyLandscape2, onDismiss: {}), namespace: namespace)
//            }
        }
    }
}
