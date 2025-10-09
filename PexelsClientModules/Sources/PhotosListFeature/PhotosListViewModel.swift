import API
import Foundation
import SwiftUI

@MainActor
public class PhotoViewModel: ObservableObject {
    @Published var photos: [PexelsPhoto] = []
    @Published var error: String? = nil
    @Published var query: String = ""

    private var page = 1
    private var currentQuery = ""

    public init(api: APIClient) {
        Task {
            do {
                photos = try await api.fetchPhotos(10, page)
                print("Photos", photos)
                self.error = nil
            } catch {
                print("ERROR", error)
                self.error = error.localizedDescription
            }
        }
    }
}
