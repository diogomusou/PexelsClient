import Extensions
import SwiftUI
import UI

public struct PhotoFullscreenView: View {
    @State private(set) var viewModel: PhotoFullscreenViewModel
    private(set) var namespace: Namespace.ID

    @State private var showInfo = false

    public init(viewModel: PhotoFullscreenViewModel, namespace: Namespace.ID) {
        self.viewModel = viewModel
        self.namespace = namespace
    }

    public var body: some View {
        ZStack {
            // Background
            Rectangle()
                .foregroundStyle(.background)
                .ignoresSafeArea()

            // Lower quality image that is displayed until the original size image is ready
            // After the original is ready, we still keep this in the view (zero opacity) so that
            // the matchedGeometryEffect works when returning to the PhotosListView.
            if let thumbnailImage = viewModel.thumbnailImage {
                thumbnailImage
                    .resizable()
                    .scaledToFit()
                    .opacity(viewModel.image == nil ? 1 : 0)
                    .frame(maxWidth: .infinity)
                    .matchedGeometryEffect(id: viewModel.photo.id, in: namespace)
            }

            if let image = viewModel.image {
                GeometryReader { geometry in
                    ZoomableImageView(
                        image: image,
                        size: geometry.size
                    )
                    .ignoresSafeArea()
                }
            } else if let error = viewModel.error {
                PlaceholderView(colorHex: viewModel.photo.avgColor, status: .error(error))
                    .frame(maxWidth: .infinity)
                    .aspectRatio(CGFloat(viewModel.photo.width) / CGFloat(viewModel.photo.height), contentMode: .fit)
            } else if viewModel.thumbnailImage != nil {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
                    .background {
                        Circle()
                            .foregroundStyle(.background.opacity(0.2))
                    }
            } else {
                PlaceholderView(colorHex: viewModel.photo.avgColor, status: .loading)
                    .frame(maxWidth: .infinity)
                    .aspectRatio(CGFloat(viewModel.photo.width) / CGFloat(viewModel.photo.height), contentMode: .fit)
            }

            // Custom toolbar
            VStack {
                HStack {
                    // Back button
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            viewModel.didTapDismiss()
                        }
                    }) {

                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.clear)
                            Image(systemName: "chevron.left")
                                .resizable( )
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 15)
                                .foregroundStyle(.foreground)
                        }
                    }
                    .optionalGlassEffect()
                    .padding(20)
                    Spacer()

                    // Info button
                    Button(action: {
                        showInfo.toggle()
                    }) {
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.clear)
                            Image(systemName: "info")
                                .resizable( )
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 15)
                                .foregroundStyle(.foreground)
                        }
                    }
                    .optionalGlassEffect()
                    .padding()
                }
                Spacer()
            }

            // TODO: improve the info view
            // Photo info overlay
            if showInfo {
                Color.black.opacity(0.8)
                    .edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Photo Information")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                    Text("Photographer: \(viewModel.photo.photographer)")
                        .foregroundColor(.white)
                    Text("Description: \(viewModel.photo.description)")
                        .foregroundColor(.white)
                    Button("Close") {
                        showInfo = false
                    }
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding()
                .background(Color.black.opacity(0.9))
                .cornerRadius(10)
            }
        }
    }
}

// Preview
#Preview {
    @Previewable @Namespace var namespace
    var image: Image {
        Color.red
            .frame(width: 4896, height: 3264)
            .asImage()
    }
    PhotoFullscreenView(viewModel: .init(photo: .dummyInvalidURL, thumbnailImage: image, onDismiss: {}), namespace: namespace)
}
