import Foundation

struct GenreList: Decodable {
    let genres: [Genres]
    
    private enum CodingKeys: String, CodingKey {
        case genres
    }
}

struct Genres: Decodable {
    let id: Int
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name
    }
}
