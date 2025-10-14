import API
import Dependencies
import Foundation
import Models
import PhotoFullscreenFeature
import SwiftUI

enum Destination {
    case photoFullscreen(viewModel: PhotoFullscreenViewModel)
}

@Observable
public class PhotoViewModel: ObservableObject {
    var photos: [PexelsPhoto] = []
    var error: String? = nil
    var isLoading = false
    var destination: Destination?
    var query: String = "" {
        didSet {
            guard oldValue != query else { return }
            Task {
                await searchAndReplacePhotos(debounce: true)
            }
        }
    }

    @ObservationIgnored
    @Dependency(APIClient.self) private var api

    private var page = 1
    private var currentQuery = ""
    private var searchTask: Task<[PexelsPhoto], Never>?
    private var previousQuery: String?
    private var previousPage: Int?


    public init() {
        Task {
            await searchAndReplacePhotos()
        }
    }

    func didRefresh() async {
        await searchAndReplacePhotos()
    }

    func didTapPhoto(_ photo: PexelsPhoto, image: Image) {
        destination = .photoFullscreen(viewModel: .init(photo: photo, thumbnailImage: image, onDismiss: { [weak self] in self?.destination = nil }))
    }

    func loadNextPage() async {
        guard !isLoading else { return }
        isLoading = true
        page += 1
        photos += await search(for: query)
        isLoading = false
    }

    func url(for photo: PexelsPhoto) -> URL? {
        // TODO: add logic to change image resolution based on device, network, etc
        URL(string: photo.src.large)
    }

    private func searchAndReplacePhotos(debounce: Bool = false) async {
        guard !isLoading else { return }
        isLoading = true
        page = Array(1...10).randomElement() ?? 1
        let newPhotos = await search(for: query, debounce: debounce)
        guard !newPhotos.isEmpty else { return }
        photos = newPhotos
        isLoading = false
    }

    private func search(for query: String, debounce: Bool = false) async -> [PexelsPhoto] {
        searchTask?.cancel()

        searchTask = Task {
            if debounce {
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s
            }
            guard !Task.isCancelled else { return [] }

            if let previousQuery, let previousPage, previousQuery == query, previousPage == page  { return [] }
            previousQuery = query
            previousPage = page

            do {
                let photos = if !query.isEmpty {
                    try await api.searchPhotos(query: query, page: page, perPage: 5)
                } else {
                    try await api.fetchPhotos(page: page, perPage: 5)
                }
                self.error = nil
                return photos
            } catch {
                if let urlError = error as? URLError, urlError.code == .cancelled { return [] }
                print("ERROR", error)
                self.error = error.localizedDescription
                return []
            }
        }

        return await searchTask?.value ?? []
    }
}
