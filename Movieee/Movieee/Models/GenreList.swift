import Foundation

struct GenreList: Decodable {
    let genres: [GenresOfMovie]
    
    private enum CodingKeys: String, CodingKey {
        case genres
    }
}
