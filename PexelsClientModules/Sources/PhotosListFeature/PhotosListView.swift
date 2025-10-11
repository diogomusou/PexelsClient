import API
import Extensions
import SwiftUI

public struct PhotosListView: View {
    @ObservedObject var viewModel: PhotoViewModel

    public init(viewModel: PhotoViewModel) {
        self.viewModel = viewModel
    }

    private var columns: [GridItem] {
        [GridItem(.flexible(minimum: 0), spacing: 8)]
    }

    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if let error = viewModel.error {
                        Text("Something went wrong. Please check your internet connection or try again later.")
                            .padding()
                            .background(.red.opacity(0.2))
                            .cornerRadius(20)
#if DEBUG
                        Text("Error: \(error)")
#endif
                    }
                    Text("Photos provided by Pexels")
                        .font(.caption)
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.photos) { photo in
                            AsyncImage(url: .init(string: photo.src.medium)) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity)
                                        .clipped()
                                case .failure(let error):
                                    EmptyView()
#if DEBUG
                                    PlaceholderView(colorHex: photo.avgColor, status: .error(error.localizedDescription))
                                        .frame(maxWidth: .infinity)
                                        .aspectRatio(CGFloat(photo.width) / CGFloat(photo.height), contentMode: .fit)
#endif
                                case .empty:
                                    PlaceholderView(colorHex: photo.avgColor, status: .loading)
                                        .frame(maxWidth: .infinity)
                                        .aspectRatio(CGFloat(photo.width) / CGFloat(photo.height), contentMode: .fit)
                                @unknown default:
                                    EmptyView()
#if DEBUG
                                    PlaceholderView(colorHex: photo.avgColor, status: .error("default"))
                                        .frame(maxWidth: .infinity)
                                        .aspectRatio(CGFloat(photo.width) / CGFloat(photo.height), contentMode: .fit)
#endif
                                }
                            }
                            .cornerRadius(30)
                            .onAppear {
                                if photo == viewModel.photos.last {
                                    Task {
                                        await viewModel.loadNextPage()
                                    }
                                }
                            }
                        }
                    }
                    .padding(8)
                }
            }
            .refreshable(action: viewModel.didRefresh)
            //            .navigationTitle("Pexels")
            .searchable(text: $viewModel.query, prompt: "Search photos...")
        }
    }
}

struct PlaceholderView: View {
    enum Status: Equatable {
        case loading
        case error(String)
    }

    var colorHex: String
    var status: Status
    @State private var animate = false

    var body: some View {
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

// MARK: - Preview
#Preview {
    PhotosListView(viewModel: .init(api: .dummy))
//    PhotosListView(viewModel: .init(api: .error))
//    PhotosListView(viewModel: .init(api: .invalidPhotoURL))
}
