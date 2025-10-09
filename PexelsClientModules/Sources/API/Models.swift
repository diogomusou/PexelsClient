public struct PexelsPhoto: Identifiable, Decodable, Equatable {
    public let id: Int
    public let width: Int
    public let height: Int
    public let photographer: String
    public let src: PhotoSrc
    public let avgColor: String

    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case photographer
        case src
        case avgColor = "avg_color"
    }
    // alt: String
}

public struct PhotoSrc: Decodable, Equatable {
    public let medium: String
}
