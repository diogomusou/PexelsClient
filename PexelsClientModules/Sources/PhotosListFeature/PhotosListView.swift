import API
import PhotoFullscreenFeature
import SwiftUI
import UI

public struct PhotosListView: View {
    @ObservedObject var viewModel: PhotoViewModel

    @Namespace private var photoNamespace
    @State private var isFullscreen = false
    @State private var selectedImage: Image?
    @State private var selectedPhoto: PexelsPhoto?

    public init(viewModel: PhotoViewModel) {
        self.viewModel = viewModel
    }

    private var columns: [GridItem] {
        [GridItem(.flexible(minimum: 0), spacing: 8)]
    }

    public var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    VStack {
                        errorBanner
                        
                        Text("Photos provided by Pexels")
                            .font(.caption)
                        
                        photoGrid
                    }
                }
                .refreshable(action: viewModel.didRefresh)
                .searchable(text: $viewModel.query, prompt: "Search photos...")
            }

            if isFullscreen, let selectedPhoto, let selectedImage {
                PhotoFullscreenView(viewModel: .init(photo: selectedPhoto, placeholder: selectedImage), namespace: photoNamespace, isPresented: $isFullscreen)
                    .transition(.opacity)
                    .zIndex(1)
            }

        }

    }

    var photoGrid: some View {
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
                            .matchedGeometryEffect(id: photo.id, in: photoNamespace)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                    selectedPhoto = photo
                                    selectedImage = image
                                    isFullscreen = true
                                }
                            }
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
    PhotosListView(viewModel: .init(api: .dummy))
//    PhotosListView(viewModel: .init(api: .error))
//    PhotosListView(viewModel: .init(api: .invalidPhotoURL))
}
