import API
import Dependencies
import Foundation
import Models

extension APIClient: DependencyKey {
    public static var liveValue: APIClient {
        .init(
            fetchPhotos: { page,perPage in
                let url = URL(string: "https://api.pexels.com/v1/curated?per_page=\(perPage)&page=\(page)")!
                let apiKey = "96Yn7nkJqOSQDxgx8OMAkVZRZHKvCcUF2JcaNIq8xMM0NZwDyq7ikGJl"

                var request = URLRequest(url: url)
                request.setValue(apiKey, forHTTPHeaderField: "Authorization")
                let data = try await URLSession.shared.data(for: request)
                let response = try JSONDecoder().decode(PexelsPhotosResponse.self, from: data.0)

                return response.photos
            },
            searchPhotos: { query, page, perPage in
                let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                let url = URL(string: "https://api.pexels.com/v1/search?query=\(encodedQuery)&per_page=\(perPage)&page=\(page)")!
                let apiKey = "96Yn7nkJqOSQDxgx8OMAkVZRZHKvCcUF2JcaNIq8xMM0NZwDyq7ikGJl"

                var request = URLRequest(url: url)
                request.setValue(apiKey, forHTTPHeaderField: "Authorization")
                let data = try await URLSession.shared.data(for: request)
                let response = try JSONDecoder().decode(PexelsPhotosResponse.self, from: data.0)

                return response.photos
            },
            fetchData: { url in
                let data = try await URLSession.shared.data(from: url)
                return data.0
            }
        )
    }
}

nonisolated
private struct PexelsPhotosResponse: Decodable {
    let photos: [PexelsPhoto]
}
