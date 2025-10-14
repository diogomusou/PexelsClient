import Testing
import SwiftUI
import UIKit

@testable import Extensions

@Suite("Color(hex:) tests")
struct ColorExtensionTests {

    @Test("Parses 6-digit hex without #")
    func parsesSixDigitHex() throws {
        let color = Color(hex: "FF0000")
        let comps = try #require(color.flatMap(components(from:)))
        #expect(comps.r == 1.0)
        #expect(comps.g == 0.0)
        #expect(comps.b == 0.0)
    }

    @Test("Parses 6-digit hex with # and trims whitespace")
    func parsesHashAndWhitespace() throws {
        let color = Color(hex: "  #00FF00  ")
        let comps = try #require(color.flatMap(components(from:)))
        #expect(comps.r == 0.0)
        #expect(comps.g == 1.0)
        #expect(comps.b == 0.0)
    }

    @Test("Parses blue and preserves full alpha by default")
    func parsesBlue() throws {
        let color = Color(hex: "0000FF")
        let comps = try #require(color.flatMap(components(from:)))
        #expect(comps.r == 0.0)
        #expect(comps.g == 0.0)
        #expect(comps.b == 1.0)
        #expect(comps.a == 1.0)
    }

    @Test("Returns nil for invalid length")
    func invalidLength() {
        #expect(Color(hex: "FFF") == nil)
        #expect(Color(hex: "FFFFFFFF") == nil)
        #expect(Color(hex: "") == nil)
    }

    @Test("Returns nil for non-hex characters")
    func invalidCharacters() {
        #expect(Color(hex: "GGGGGG") == nil)
        #expect(Color(hex: "12Z45Q") == nil)
    }

    @Test("Parses mixed-case hex")
    func mixedCase() throws {
        let colorLower = try #require(Color(hex: "a1b2c3"))
        let colorUpper = try #require(Color(hex: "A1B2C3"))
        let compsLower = try #require(components(from: colorLower))
        let compsUpper = try #require(components(from: colorUpper))
        #expect(compsLower.r == compsUpper.r)
        #expect(compsLower.g == compsUpper.g)
        #expect(compsLower.b == compsUpper.b)
    }

    private func components(from color: Color) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)? {
        let uiColor = UIColor(color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else { return nil }
        return (r, g, b, a)
    }
}
