import Extensions
import Foundation
import SwiftUI

public struct PlaceholderView: View {
    public enum Status: Equatable {
        case loading
        case error(String)
    }

    public var colorHex: String
    public var status: Status

    @State private var animate = false

    public init(colorHex: String, status: Status) {
        self.colorHex = colorHex
        self.status = status
    }

    public var body: some View {
        ZStack {
            switch status {
            case .loading:
                ProgressView()
                    .scaleEffect(1.5)
            case .error(let error):
                VStack {
                    Text("Something went wrong.")
#if DEBUG
                    Text("Error: \(error)")
#endif
                }
                .padding()
            }

            Color(hex: colorHex)
                .opacity(animate ? 0.2 : 0.4)
                .animation(
                    .easeInOut(duration: 1.2)
                    .repeatForever(autoreverses: true),
                    value: animate
                )
                .onAppear {
                    if status == .loading {
                        animate = true
                    }
                }
        }
    }
}
