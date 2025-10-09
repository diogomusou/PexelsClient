import Foundation

public extension APIClient {
    static var live: APIClient {
        .init(
            fetchPhotos: { perPage,page in
                let url = URL(string: "https://api.pexels.com/v1/curated?per_page=\(perPage)&page=\(page)")!
                let apiKey = ""

                var request = URLRequest(url: url)
                request.setValue(apiKey, forHTTPHeaderField: "Authorization")
                let data = try await URLSession.shared.data(for: request)
                let response = try JSONDecoder().decode(PexelsPhotosResponse.self, from: data.0)

                return response.photos
            }
        )
    }
}

private struct PexelsPhotosResponse: Decodable {
    let photos: [PexelsPhoto]
}
