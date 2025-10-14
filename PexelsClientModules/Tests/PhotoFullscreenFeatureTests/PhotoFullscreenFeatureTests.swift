import ConcurrencyExtras
import Dependencies
import Foundation
import Testing

@testable import PhotoFullscreenFeature

@Suite("PhotoFullscreenViewModel tests")
struct PhotoFullscreenFeatureTests {

    @Test func modelInit() async throws {
        let model = PhotoFullscreenViewModel(photo: .dummyInvalidURL, thumbnailImage: nil, onDismiss: { })
        #expect(model.photo == .dummyInvalidURL)
        #expect(model.thumbnailImage == nil)
    }

    @Test func onDismiss() async throws {
        var didDismiss = false
        let model = PhotoFullscreenViewModel(photo: .dummyInvalidURL, thumbnailImage: nil, onDismiss: { didDismiss = true })
        #expect(didDismiss == false)
        model.didTapDismiss()
        #expect(didDismiss == true)
    }

    @Test func invalidURLError() async throws {
        let model = PhotoFullscreenViewModel(photo: .dummyInvalidURL, thumbnailImage: nil, onDismiss: {})
        await Task.yield()
        #expect(model.error == "Invalid URL")
    }

    @Test func imageIsLoaded() async throws {
        await withMainSerialExecutor {
            await withDependencies {
                $0.api = .dummy
                $0.continuousClock = .immediate
            } operation: {
                let model = PhotoFullscreenViewModel(photo: .dummyPortrait1, thumbnailImage: nil, onDismiss: {})
                await Task.megaYield()
                await Task.megaYield()
                #expect(model.error == nil)
                #expect(model.image != nil)
            }
        }
    }

    @Test func networkError() async throws {
        await withMainSerialExecutor {
            await withDependencies {
                $0.api = .error
                $0.continuousClock = .immediate
            } operation: {
                let model = PhotoFullscreenViewModel(photo: .dummyPortrait1, thumbnailImage: nil, onDismiss: {})
                await Task.megaYield()
                await Task.megaYield()
                #expect(model.error == URLError(.notConnectedToInternet).localizedDescription)
                #expect(model.image == nil)
            }

        }
    }

}
