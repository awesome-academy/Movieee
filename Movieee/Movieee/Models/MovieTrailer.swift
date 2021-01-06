import Foundation

struct MovieTrailer: Decodable {
    let id: Int
    let results: [MovieYoutubeTrailer]
    
    private enum CodingKeys: String, CodingKey {
        case id, results
    }
}

struct MovieYoutubeTrailer: Decodable {
    let key: String
    
    private enum CodingKeys: String, CodingKey {
        case key
    }
}
