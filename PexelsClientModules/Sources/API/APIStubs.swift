import Foundation
import Models

public extension APIClient {
    static var error: APIClient {
        .init(
            fetchPhotos: { _, _ in
                throw URLError(.notConnectedToInternet)
            },
            searchPhotos: { _, _, _ in
                throw URLError(.notConnectedToInternet)
            },
            fetchData: { _ in
                throw URLError(.notConnectedToInternet)
            }
        )
    }

    static var invalidPhotoURL: APIClient {
        .init(
            fetchPhotos: { _, _ in
                [.dummyInvalidURL]
            },
            searchPhotos: { _, _, _ in
                [.dummyInvalidURL]
            },
            fetchData: { _ in
                Data()
            }
        )
    }

    static var empty: APIClient {
        .init(
            fetchPhotos: { _, _ in
                []
            },
            searchPhotos: { _, _, _ in
                []
            },
            fetchData: { _ in
                Data()
            }
        )
    }

    static var one: APIClient {
        .init(
            fetchPhotos: { _, _ in
                [.dummyLandscape1]
            },
            searchPhotos: { _, _, _ in
                [.dummyLandscape1]
            },
            fetchData: { _ in
                .black2x2PNG
            }
        )
    }

    static var dummy: APIClient {
        .init(
            fetchPhotos: { _, _ in
//                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1.0s
                return [
                    .dummyPortrait1,
                    .dummyLandscape1,
                    .dummyPortrait2,
                    .dummySquare,
                    .dummyLandscape2
                ].shuffled()
            }, searchPhotos: { _, _, _ in
//                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1.0s
                return [
                    .dummyLandscape1,
                    .dummyPortrait1,
                    .dummyPortrait2,
                    .dummySquare,
                    .dummyLandscape2
                ].shuffled()
            }, fetchData: { _ in
                .black2x2PNG
            }
        )
    }
}

public extension PexelsPhoto {

    // Dummies are using a lower resolution for efficiency

    static var dummyLandscape1: PexelsPhoto {
        .init(
            id: 96420,
            width: 4896,
            height: 3264,
            photographer: "Francesco Ungaro",
            src: .init(
                large: "https://images.pexels.com/photos/96420/pexels-photo-96420.jpeg?auto=compress&cs=tinysrgb&h=350",
                medium: "https://images.pexels.com/photos/96420/pexels-photo-96420.jpeg?auto=compress&cs=tinysrgb&h=130",
                original: "https://images.pexels.com/photos/96420/pexels-photo-96420.jpeg"
            ),
            avgColor: "#77220B"
        )
    }

    static var dummyLandscape2: PexelsPhoto {
        .init(
            id: 210547,
            width: 4928,
            height: 3280,
            photographer: "Pixabay",
            src: .init(
                large: "https://images.pexels.com/photos/210547/pexels-photo-210547.jpeg?auto=compress&cs=tinysrgb&h=350",
                medium: "https://images.pexels.com/photos/210547/pexels-photo-210547.jpeg?auto=compress&cs=tinysrgb&h=130",
                original: "https://images.pexels.com/photos/210547/pexels-photo-210547.jpeg"
            ),
            avgColor: "#9B755B"
        )
    }

    static var dummyPortrait1: PexelsPhoto {
        .init(
            id: 581299,
            width: 3432,
            height: 5152,
            photographer: "Aden Ardenrich",
            src: .init(
                large: "https://images.pexels.com/photos/581299/pexels-photo-581299.jpeg?auto=compress&cs=tinysrgb&h=350",
                medium: "https://images.pexels.com/photos/581299/pexels-photo-581299.jpeg?auto=compress&cs=tinysrgb&h=130",
                original: "https://images.pexels.com/photos/581299/pexels-photo-581299.jpeg"
            ),
            avgColor: "#3F3325"
        )
    }

    static var dummyPortrait2: PexelsPhoto {
        .init(
            id: 3408353,
            width: 4160,
            height: 6240,
            photographer: "Tomáš Malík",
            src: .init(
                large: "https://images.pexels.com/photos/3408353/pexels-photo-3408353.jpeg?auto=compress&cs=tinysrgb&h=350",
                medium: "https://images.pexels.com/photos/3408353/pexels-photo-3408353.jpeg?auto=compress&cs=tinysrgb&h=130",
                original: "https://images.pexels.com/photos/3408353/pexels-photo-3408353.jpeg"
            ),
            avgColor: "#757F8A"
        )
    }

    static var dummySquare: PexelsPhoto {
        .init(
            id: 601174,
            width: 2415,
            height: 2415,
            photographer: "Tirachard Kumtanom",
            src: .init(
                large: "https://images.pexels.com/photos/601174/pexels-photo-601174.jpeg?auto=compress&cs=tinysrgb&h=350",
                medium: "https://images.pexels.com/photos/601174/pexels-photo-601174.jpeg?auto=compress&cs=tinysrgb&h=130",
                original: "https://images.pexels.com/photos/601174/pexels-photo-601174.jpeg"
            ),
            avgColor: "#7E86A8"
        )
    }

    static var dummyInvalidURL: PexelsPhoto {
        .init(
            id: 96420,
            width: 4896,
            height: 3264,
            photographer: "Francesco Ungaro",
            src: .init(
                large: "",
                medium: "",
                original: ""
            ),
            avgColor: "#77220B"
        )
    }

    static var dummyWrongURL: PexelsPhoto {
        .init(
            id: 96420,
            width: 4896,
            height: 3264,
            photographer: "Francesco Ungaro",
            src: .init(
                large: "https://jsonplaceholder.typicode.com/todos/1",
                medium: "https://jsonplaceholder.typicode.com/todos/1",
                original: "https://jsonplaceholder.typicode.com/todos/1"
            ),
            avgColor: "#77220B"
        )
    }
}

public extension Data {
    static var black2x2PNG: Data {
        Data(base64Encoded: "iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAYAAABytg0kAAAAFElEQVR4nGNkYGD4z8DAwMDEAAUADigBA0dwHFEAAAAASUVORK5CYII=")!
        }
}
