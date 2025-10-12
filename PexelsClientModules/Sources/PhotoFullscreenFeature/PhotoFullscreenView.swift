import SwiftUI
import UI

public struct PhotoFullscreenView: View {
    @ObservedObject var viewModel: PhotoFullscreenViewModel
    var namespace: Namespace.ID
    @Binding var isPresented: Bool

    @State private var showInfo = false

    public init(viewModel: PhotoFullscreenViewModel, namespace: Namespace.ID, isPresented: Binding<Bool>) {
        self.viewModel = viewModel
        self.namespace = namespace
        self._isPresented = isPresented
    }

    public var body: some View {
        ZStack {
            
            Rectangle()
                .foregroundStyle(.background)
                .ignoresSafeArea()

            if let placeholder = viewModel.placeholder {
                    placeholder
                        .resizable()
                        .scaledToFit()
                        .opacity(viewModel.image == nil ? 1 : 0)
                        .frame(maxWidth: .infinity)
                        .matchedGeometryEffect(id: viewModel.photo.id, in: namespace)
            }
                if let image = viewModel.image {
                    GeometryReader { geo in
                        ZoomableImageView(
                            image: image,
                            size: geo.size
                        )
                        .ignoresSafeArea()
                    }
                } else if let error = viewModel.error {
                    PlaceholderView(colorHex: viewModel.photo.avgColor, status: .error(error))
                        .frame(maxWidth: .infinity)
                        .aspectRatio(CGFloat(viewModel.photo.width) / CGFloat(viewModel.photo.height), contentMode: .fit)
                } else if viewModel.placeholder != nil {
                    ProgressView()
                        .scaleEffect(1.5)
                } else {
                    PlaceholderView(colorHex: viewModel.photo.avgColor, status: .loading)
                        .frame(maxWidth: .infinity)
                        .aspectRatio(CGFloat(viewModel.photo.width) / CGFloat(viewModel.photo.height), contentMode: .fit)
                }
            
            // Custom toolbar
            VStack {
                HStack {
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            isPresented = false
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
                    Link("View Profile", destination: URL(string: "https://www.google.com")!)
                        .foregroundColor(.blue)
                        .padding()
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
    @Previewable @State var isPresented = true
    var image: Image {
        Color.red
            .frame(width: 4896, height: 3264)
            .asImage()
    }
    PhotoFullscreenView(viewModel: .init(photo: .dummyWrongURL, placeholder: image), namespace: namespace, isPresented: $isPresented)
}

extension View {
    @ViewBuilder func optionalGlassEffect() -> some View {
        if #available(iOS 26, *) {
            glassEffect(.clear.tint(.gray.opacity(0.3)))
        } else {
            self
        }
    }
}

public extension View {
    func asImage() -> Image {
        let renderer = ImageRenderer(content: self)
        guard let image = renderer.uiImage else { return Image(systemName: "xmark") }
        return Image(uiImage: image)
    }
}
