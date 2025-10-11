import API
import Foundation
import SwiftUI

@MainActor
public class PhotoViewModel: ObservableObject {
    @Published var photos: [PexelsPhoto] = []
    @Published var error: String? = nil
    @Published var query: String = "" {
        didSet {
            guard oldValue != query else { return }
            Task {
                await searchAndReplacePhotos(debounce: true)
            }
        }
    }

    private var page = 1
    private var currentQuery = ""
    private var api: APIClient
    private var searchTask: Task<[PexelsPhoto], Never>?
    private var previousQuery: String?
    private var previousPage: Int?
    private var isLoadingNextPage = false

    public init(api: APIClient) {
        self.api = api

        Task {
            await searchAndReplacePhotos()
        }
    }

    func didRefresh() async {
        print("REFRESH")
        await searchAndReplacePhotos()
    }

    func loadNextPage() async {
        guard !isLoadingNextPage else { return }
        isLoadingNextPage = true
        page += 1
        photos += await search(for: query)
        isLoadingNextPage = false
    }

    private func searchAndReplacePhotos(debounce: Bool = false) async {
        page = Array(1...10).randomElement() ?? 1
        let newPhotos = await search(for: query, debounce: debounce)
        guard !newPhotos.isEmpty else { return }
        photos = newPhotos
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
                    try await api.searchPhotos(query, 5, page)
                } else {
                    try await api.fetchPhotos(5, page)
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
