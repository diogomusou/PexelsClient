import Foundation

public struct PexelsPhoto: Identifiable, Decodable, Equatable, Sendable {
    public let id: Int
    public let width: Int
    public let height: Int
    public let photographer: String
    public let src: PhotoSource
    public let avgColor: String
    public let description: String

    public var aspectRatio: CGFloat {
        CGFloat(width) / CGFloat(height)
    }

    public init(id: Int, width: Int, height: Int, photographer: String, src: PhotoSource, avgColor: String, description: String) {
        self.id = id
        self.width = width
        self.height = height
        self.photographer = photographer
        self.src = src
        self.avgColor = avgColor
        self.description = description
    }

    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case photographer
        case src
        case avgColor = "avg_color"
        case description = "alt"
    }
    // alt: String
}

public struct PhotoSource: Decodable, Equatable, Sendable {
    public let large: String
    public let medium: String
    public let original: String

    public init(large: String, medium: String, original: String) {
        self.large = large
        self.medium = medium
        self.original = original
    }
}
