import Foundation

public extension APIClient {
    static var error: APIClient {
        .init(
            fetchPhotos: { _, _ in
                throw URLError(.notConnectedToInternet)
            },
            searchPhotos: { _, _, _ in
                throw URLError(.notConnectedToInternet)
            }
        )
    }

    static var invalidPhotoURL: APIClient {
        .init(
            fetchPhotos: { _, _ in
                [.init(id: 96420, width: 4896, height: 3264, photographer: "Francesco Ungaro", src: .init(medium: "https://im"), avgColor: "#77220B")]
            },
            searchPhotos: { _, _, _ in
                [.init(id: 96420, width: 4896, height: 3264, photographer: "Francesco Ungaro", src: .init(medium: "https://im"), avgColor: "#77220B")]
            }
        )
    }

    static var empty: APIClient {
        .init(
            fetchPhotos: { _, _ in
                []
            },
            searchPhotos: { _, _, _ in
                []
            }
        )
    }

    static var one: APIClient {
        .init(
            fetchPhotos: { _, _ in
                [.init(id: 96420, width: 4896, height: 3264, photographer: "Francesco Ungaro", src: .init(medium: "https://images.pexels.com/photos/96420/pexels-photo-96420.jpeg?auto=compress&cs=tinysrgb&h=130"), avgColor: "#77220B")]
            },
            searchPhotos: { _, _, _ in
                [.init(id: 96420, width: 4896, height: 3264, photographer: "Francesco Ungaro", src: .init(medium: "https://images.pexels.com/photos/96420/pexels-photo-96420.jpeg?auto=compress&cs=tinysrgb&h=130"), avgColor: "#77220B")]
            }
        )
    }

    static var dummy: APIClient {
        .init(
            fetchPhotos: { _, _ in
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1.0s
                return [
                    .init(id: 581299, width: 3432, height: 5152, photographer: "Aden Ardenrich", src: .init(medium: "https://images.pexels.com/photos/581299/pexels-photo-581299.jpeg?auto=compress&cs=tinysrgb&h=130"), avgColor: "#3F3325"),
                    .init(id: 96420, width: 4896, height: 3264, photographer: "Francesco Ungaro", src: .init(medium: "https://images.pexels.com/photos/96420/pexels-photo-96420.jpeg?auto=compress&cs=tinysrgb&h=130"), avgColor: "#77220B"),
                    .init(id: 3408353, width: 4160, height: 6240, photographer: "Tomáš Malík", src: .init(medium: "https://images.pexels.com/photos/3408353/pexels-photo-3408353.jpeg?auto=compress&cs=tinysrgb&h=130"), avgColor: "#757F8A"),
                    .init(id: 601174, width: 2415, height: 2415, photographer: "Tirachard Kumtanom", src: .init(medium: "https://images.pexels.com/photos/601174/pexels-photo-601174.jpeg?auto=compress&cs=tinysrgb&h=130"), avgColor: "#7E86A8"),
                    .init(id: 210547, width: 4928, height: 3280, photographer: "Pixabay", src: .init(medium: "https://images.pexels.com/photos/210547/pexels-photo-210547.jpeg?auto=compress&cs=tinysrgb&h=130"), avgColor: "#9B755B")
                ].shuffled()
            }, searchPhotos: { _, _, _ in
                try? await Task.sleep(nanoseconds: 1_000_000_000) // 1.0s
                return [
                    .init(id: 96420, width: 4896, height: 3264, photographer: "Francesco Ungaro", src: .init(medium: "https://images.pexels.com/photos/96420/pexels-photo-96420.jpeg?auto=compress&cs=tinysrgb&h=130"), avgColor: "#77220B"),
                    .init(id: 581299, width: 3432, height: 5152, photographer: "Aden Ardenrich", src: .init(medium: "https://images.pexels.com/photos/581299/pexels-photo-581299.jpeg?auto=compress&cs=tinysrgb&h=130"), avgColor: "#3F3325"),
                    .init(id: 3408353, width: 4160, height: 6240, photographer: "Tomáš Malík", src: .init(medium: "https://images.pexels.com/photos/3408353/pexels-photo-3408353.jpeg?auto=compress&cs=tinysrgb&h=130"), avgColor: "#757F8A"),
                    .init(id: 601174, width: 2415, height: 2415, photographer: "Tirachard Kumtanom", src: .init(medium: "https://images.pexels.com/photos/601174/pexels-photo-601174.jpeg?auto=compress&cs=tinysrgb&h=130"), avgColor: "#7E86A8"),
                    .init(id: 210547, width: 4928, height: 3280, photographer: "Pixabay", src: .init(medium: "https://images.pexels.com/photos/210547/pexels-photo-210547.jpeg?auto=compress&cs=tinysrgb&h=130"), avgColor: "#9B755B")
                ].shuffled()
            }
        )
    }
}

// curl -H "Authorization: 96Yn7nkJqOSQDxgx8OMAkVZRZHKvCcUF2JcaNIq8xMM0NZwDyq7ikGJl" "https://api.pexels.com/v1/photos/210547"

// photo1
// {"id":581299,"width":3432,"height":5152,"url":"https://www.pexels.com/photo/chinese-lantern-lot-581299/","photographer":"Aden Ardenrich","photographer_url":"https://www.pexels.com/@aden-ardenrich-181745","photographer_id":181745,"avg_color":"#3F3325","src":{"original":"https://images.pexels.com/photos/581299/pexels-photo-581299.jpeg","large2x":"https://images.pexels.com/photos/581299/pexels-photo-581299.jpeg?auto=compress\u0026cs=tinysrgb\u0026dpr=2\u0026h=650\u0026w=940","large":"https://images.pexels.com/photos/581299/pexels-photo-581299.jpeg?auto=compress\u0026cs=tinysrgb\u0026h=650\u0026w=940","medium":"https://images.pexels.com/photos/581299/pexels-photo-581299.jpeg?auto=compress\u0026cs=tinysrgb\u0026h=350","small":"https://images.pexels.com/photos/581299/pexels-photo-581299.jpeg?auto=compress\u0026cs=tinysrgb\u0026h=130","portrait":"https://images.pexels.com/photos/581299/pexels-photo-581299.jpeg?auto=compress\u0026cs=tinysrgb\u0026fit=crop\u0026h=1200\u0026w=800","landscape":"https://images.pexels.com/photos/581299/pexels-photo-581299.jpeg?auto=compress\u0026cs=tinysrgb\u0026fit=crop\u0026h=627\u0026w=1200","tiny":"https://images.pexels.com/photos/581299/pexels-photo-581299.jpeg?auto=compress\u0026cs=tinysrgb\u0026dpr=1\u0026fit=crop\u0026h=200\u0026w=280"},"liked":false,"alt":"Rows of traditional Japanese paper lanterns glowing warmly in the night."}

// photo3

// {"id":3408353,"width":4160,"height":6240,"url":"https://www.pexels.com/photo/mt-fuji-3408353/","photographer":"Tomáš Malík","photographer_url":"https://www.pexels.com/@tomas-malik-793526","photographer_id":793526,"avg_color":"#757F8A","src":{"original":"https://images.pexels.com/photos/3408353/pexels-photo-3408353.jpeg","large2x":"https://images.pexels.com/photos/3408353/pexels-photo-3408353.jpeg?auto=compress\u0026cs=tinysrgb\u0026dpr=2\u0026h=650\u0026w=940","large":"https://images.pexels.com/photos/3408353/pexels-photo-3408353.jpeg?auto=compress\u0026cs=tinysrgb\u0026h=650\u0026w=940","medium":"https://images.pexels.com/photos/3408353/pexels-photo-3408353.jpeg?auto=compress\u0026cs=tinysrgb\u0026h=350","small":"https://images.pexels.com/photos/3408353/pexels-photo-3408353.jpeg?auto=compress\u0026cs=tinysrgb\u0026h=130","portrait":"https://images.pexels.com/photos/3408353/pexels-photo-3408353.jpeg?auto=compress\u0026cs=tinysrgb\u0026fit=crop\u0026h=1200\u0026w=800","landscape":"https://images.pexels.com/photos/3408353/pexels-photo-3408353.jpeg?auto=compress\u0026cs=tinysrgb\u0026fit=crop\u0026h=627\u0026w=1200","tiny":"https://images.pexels.com/photos/3408353/pexels-photo-3408353.jpeg?auto=compress\u0026cs=tinysrgb\u0026dpr=1\u0026fit=crop\u0026h=200\u0026w=280"},"liked":false,"alt":"Stunning view of Chureito Pagoda and snow-capped Mount Fuji, Fujinomiya, Japan."}

// photo2
// {"id":96420,"width":4896,"height":3264,"url":"https://www.pexels.com/photo/blue-and-orange-wooden-pathway-96420/","photographer":"Francesco Ungaro","photographer_url":"https://www.pexels.com/@francesco-ungaro","photographer_id":21273,"avg_color":"#77220B","src":{"original":"https://images.pexels.com/photos/96420/pexels-photo-96420.jpeg","large2x":"https://images.pexels.com/photos/96420/pexels-photo-96420.jpeg?auto=compress\u0026cs=tinysrgb\u0026dpr=2\u0026h=650\u0026w=940","large":"https://images.pexels.com/photos/96420/pexels-photo-96420.jpeg?auto=compress\u0026cs=tinysrgb\u0026h=650\u0026w=940","medium":"https://images.pexels.com/photos/96420/pexels-photo-96420.jpeg?auto=compress\u0026cs=tinysrgb\u0026h=350","small":"https://images.pexels.com/photos/96420/pexels-photo-96420.jpeg?auto=compress\u0026cs=tinysrgb\u0026h=130","portrait":"https://images.pexels.com/photos/96420/pexels-photo-96420.jpeg?auto=compress\u0026cs=tinysrgb\u0026fit=crop\u0026h=1200\u0026w=800","landscape":"https://images.pexels.com/photos/96420/pexels-photo-96420.jpeg?auto=compress\u0026cs=tinysrgb\u0026fit=crop\u0026h=627\u0026w=1200","tiny":"https://images.pexels.com/photos/96420/pexels-photo-96420.jpeg?auto=compress\u0026cs=tinysrgb\u0026dpr=1\u0026fit=crop\u0026h=200\u0026w=280"},"liked":false,"alt":"Explore the stunning orange torii gates of Fushimi Inari Taisha in Kyoto, Japan."}

// photo4
// {"id":601174,"width":2415,"height":2415,"url":"https://www.pexels.com/photo/scenic-view-of-mount-fuji-601174/","photographer":"Tirachard Kumtanom","photographer_url":"https://www.pexels.com/@tirachard-kumtanom-112571","photographer_id":112571,"avg_color":"#7E86A8","src":{"original":"https://images.pexels.com/photos/601174/pexels-photo-601174.jpeg","large2x":"https://images.pexels.com/photos/601174/pexels-photo-601174.jpeg?auto=compress\u0026cs=tinysrgb\u0026dpr=2\u0026h=650\u0026w=940","large":"https://images.pexels.com/photos/601174/pexels-photo-601174.jpeg?auto=compress\u0026cs=tinysrgb\u0026h=650\u0026w=940","medium":"https://images.pexels.com/photos/601174/pexels-photo-601174.jpeg?auto=compress\u0026cs=tinysrgb\u0026h=350","small":"https://images.pexels.com/photos/601174/pexels-photo-601174.jpeg?auto=compress\u0026cs=tinysrgb\u0026h=130","portrait":"https://images.pexels.com/photos/601174/pexels-photo-601174.jpeg?auto=compress\u0026cs=tinysrgb\u0026fit=crop\u0026h=1200\u0026w=800","landscape":"https://images.pexels.com/photos/601174/pexels-photo-601174.jpeg?auto=compress\u0026cs=tinysrgb\u0026fit=crop\u0026h=627\u0026w=1200","tiny":"https://images.pexels.com/photos/601174/pexels-photo-601174.jpeg?auto=compress\u0026cs=tinysrgb\u0026dpr=1\u0026fit=crop\u0026h=200\u0026w=280"},"liked":false,"alt":"Stunning view of Mount Fuji framed by vibrant autumn maple leaves at a serene lake."}%

// photo5
// {"id":210547,"width":4928,"height":3280,"url":"https://www.pexels.com/photo/brown-wooden-door-near-body-of-water-210547/","photographer":"Pixabay","photographer_url":"https://www.pexels.com/@pixabay","photographer_id":2659,"avg_color":"#9B755B","src":{"original":"https://images.pexels.com/photos/210547/pexels-photo-210547.jpeg","large2x":"https://images.pexels.com/photos/210547/pexels-photo-210547.jpeg?auto=compress\u0026cs=tinysrgb\u0026dpr=2\u0026h=650\u0026w=940","large":"https://images.pexels.com/photos/210547/pexels-photo-210547.jpeg?auto=compress\u0026cs=tinysrgb\u0026h=650\u0026w=940","medium":"https://images.pexels.com/photos/210547/pexels-photo-210547.jpeg?auto=compress\u0026cs=tinysrgb\u0026h=350","small":"https://images.pexels.com/photos/210547/pexels-photo-210547.jpeg?auto=compress\u0026cs=tinysrgb\u0026h=130","portrait":"https://images.pexels.com/photos/210547/pexels-photo-210547.jpeg?auto=compress\u0026cs=tinysrgb\u0026fit=crop\u0026h=1200\u0026w=800","landscape":"https://images.pexels.com/photos/210547/pexels-photo-210547.jpeg?auto=compress\u0026cs=tinysrgb\u0026fit=crop\u0026h=627\u0026w=1200","tiny":"https://images.pexels.com/photos/210547/pexels-photo-210547.jpeg?auto=compress\u0026cs=tinysrgb\u0026dpr=1\u0026fit=crop\u0026h=200\u0026w=280"},"liked":false,"alt":"Traditional Japanese room with shoji screens and a view of a serene garden pond."}
