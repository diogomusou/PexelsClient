public struct APIClient {
    public var fetchPhotos: (_ perPage: Int, _ page: Int) async throws -> [PexelsPhoto]
    public var searchPhotos: (_ query: String, _ perPage: Int, _ page: Int) async throws -> [PexelsPhoto]

    public init(
        fetchPhotos: @escaping (_: Int, _: Int) async throws -> [PexelsPhoto],
        searchPhotos: @escaping (_: String, _: Int, _: Int) async throws -> [PexelsPhoto]
    ) {
        self.fetchPhotos = fetchPhotos
        self.searchPhotos = searchPhotos
    }
}
