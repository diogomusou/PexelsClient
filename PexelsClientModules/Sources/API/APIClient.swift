import Foundation
import Models

// Using Protocol Witnesses instead of traditional protocols

public struct APIClient: Sendable {
    private var _fetchPhotos: @Sendable (_ page: Int, _ perPage: Int) async throws -> [PexelsPhoto]
    private var _searchPhotos: @Sendable (_ query: String, _ perPage: Int, _ page: Int) async throws -> [PexelsPhoto]
    private var _fetchData: @Sendable (_ url: URL) async throws -> Data

    public init(
        fetchPhotos: @escaping @Sendable (_: Int, _: Int) async throws -> [PexelsPhoto],
        searchPhotos: @escaping @Sendable (_: String, _: Int, _: Int) async throws -> [PexelsPhoto],
        fetchData: @escaping @Sendable (_: URL) async throws -> Data
    ) {
        _fetchPhotos = fetchPhotos
        _searchPhotos = searchPhotos
        _fetchData = fetchData
    }

    // We could use the properties above directly, but they don't show the parameter names
    // In order to show the parameter names to the callers, we create these functions

    public func fetchPhotos(page: Int, perPage: Int) async throws -> [PexelsPhoto] {
        try await _fetchPhotos(page, perPage)
    }

    public func searchPhotos(query: String, page: Int, perPage: Int) async throws -> [PexelsPhoto] {
        try await _searchPhotos(query, page, perPage)
    }

    public func fetchData(from url: URL) async throws -> Data {
        try await _fetchData(url)
    }
}
