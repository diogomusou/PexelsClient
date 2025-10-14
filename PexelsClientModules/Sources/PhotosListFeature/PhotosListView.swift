import API
import Dependencies
import PhotoFullscreenFeature
import SwiftUI
import UI

public struct PhotosListView: View {
    @State private var viewModel = PhotoViewModel()

    @Namespace private var photoNamespace

    public init() {}

    private var columns: [GridItem] {
        [GridItem(.flexible(minimum: 0), spacing: 8)]
    }

    public var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack {
                        errorBanner

                        // TODO: localization
                        Text("Photos provided by Pexels")
                            .font(.caption)

                        photoGrid

                        if viewModel.isLoading {
                            ProgressView()
                        }
                    }
                }
                .refreshable(action: viewModel.didRefresh)
                .searchable(text: $viewModel.query, prompt: "Search photos...")
            }

            if let destination = viewModel.destination {
                switch destination {
                case .photoFullscreen(viewModel: let viewModel):
                    PhotoFullscreenView(viewModel: viewModel, namespace: photoNamespace)
                        .transition(.opacity)
                        .zIndex(1)
                }
            }

        }

    }

    var photoGrid: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(viewModel.photos) { photo in
                AsyncImage(url: viewModel.url(for: photo)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .matchedGeometryEffect(id: photo.id, in: photoNamespace)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    viewModel.didTapPhoto(photo, image: image)
                                }
                            }
                    case .failure:
                        EmptyView()
//#if DEBUG
//                        PlaceholderView(colorHex: photo.avgColor, status: .error("error.localizedDescription"))
//                            .frame(maxWidth: .infinity)
//                            .aspectRatio(CGFloat(photo.width) / CGFloat(photo.height), contentMode: .fit)
//#endif
                    case .empty:
                        PlaceholderView(colorHex: photo.avgColor, status: .loading)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(photo.aspectRatio, contentMode: .fit)
                    @unknown default:
                        EmptyView()
#if DEBUG
                        PlaceholderView(colorHex: photo.avgColor, status: .error("default"))
                            .frame(maxWidth: .infinity)
                            .aspectRatio(photo.aspectRatio, contentMode: .fit)
#endif
                    }
                }
                .cornerRadius(30)
                .onAppear {
                    guard photo == viewModel.photos.last else { return }
                    Task {
                        await viewModel.loadNextPage()
                    }
                }
            }
        }
        .padding(8)
    }

    var errorBanner: some View {
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
        }
    }
}

// MARK: - Preview
#Preview {
    withDependencies {
        $0.api = .one
    } operation: {
        PhotosListView()
    }
}
