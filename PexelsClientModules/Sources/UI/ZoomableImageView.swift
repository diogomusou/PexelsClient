import Foundation
import SwiftUI
import UIKit

public struct ZoomableImageView: UIViewRepresentable {
    let image: UIImage
    let size: CGSize

    public init(image: UIImage, size: CGSize) {
        self.image = image
        self.size = size
    }

    public func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 5
        scrollView.bouncesZoom = true
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = context.coordinator

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true

        scrollView.addSubview(imageView)
        context.coordinator.imageView = imageView

        // Double tap gesture to zoom in/out
        let doubleTap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleDoubleTap(_:)))
        doubleTap.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTap)

        return scrollView
    }

    public func updateUIView(_ scrollView: UIScrollView, context: Context) {
        guard let imageView = context.coordinator.imageView else { return }
        if imageView.image == nil {
            DispatchQueue.main.async {
                print("update1")
                imageView.image = image
                imageView.frame = CGRect(origin: .zero, size: image.size)
                scrollView.contentSize = image.size
                // After imageView.image is set and scrollView.contentSize = uiImage.size
                let minScale = min(
                    size.width / image.size.width,
                    size.height / image.size.height
                )
                scrollView.minimumZoomScale = minScale
                scrollView.zoomScale = minScale
                self.centerImage(in: scrollView, imageView: imageView)
            }
        } else {
            print("update2")
            let minScale = min(
                size.width / image.size.width,
                size.height / image.size.height
            )

            // Keep the current relative zoom level if the user is zoomed in,
            // but reset properly if they’re at min scale
            let wasAtMin = abs(scrollView.zoomScale - scrollView.minimumZoomScale) < 0.01
            scrollView.minimumZoomScale = minScale

            if wasAtMin {
                scrollView.zoomScale = minScale
            }

            self.centerImage(in: scrollView, imageView: imageView)
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    private func centerImage(in scrollView: UIScrollView, imageView: UIImageView) {
        let scrollSize = size
        let imageSize = imageView.frame.size
        let horizontalInset = max(0, (scrollSize.width - imageSize.width) / 2)
        let verticalInset = max(0, (scrollSize.height - imageSize.height) / 2)
        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: 0, right: 0)
    }

    public class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: ZoomableImageView
        weak var imageView: UIImageView?

        init(_ parent: ZoomableImageView) {
            self.parent = parent
        }

        public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            imageView
        }

        public func scrollViewDidZoom(_ scrollView: UIScrollView) {
            if let imageView = imageView {
                parent.centerImage(in: scrollView, imageView: imageView)
            }
        }

        @objc func handleDoubleTap(_ gesture: UITapGestureRecognizer) {
            guard let scrollView = gesture.view as? UIScrollView else { return }

            if scrollView.zoomScale > scrollView.minimumZoomScale {
                // Zoom out
                scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
            } else {
                // Zoom in
                let tapPoint = gesture.location(in: imageView)
                let fillScale = max(
                    scrollView.bounds.size.width / (imageView?.bounds.size.width ?? 1),
                    scrollView.bounds.size.height / (imageView?.bounds.size.height ?? 1)
                )
                let newZoomScale = max(fillScale, scrollView.minimumZoomScale)

                let scrollSize = scrollView.bounds.size
                let width = scrollSize.width / newZoomScale
                let height = scrollSize.height / newZoomScale
                let x = tapPoint.x - (width / 2)
                let y = tapPoint.y - (height / 2)

                let zoomRect = CGRect(x: x, y: y, width: width, height: height)
                scrollView.zoom(to: zoomRect, animated: true)
            }
        }
    }
}
