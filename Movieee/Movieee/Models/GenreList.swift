import Foundation

struct GenreList: Decodable {
    let genres: [ListNameOfGenre]
    
    private enum CodingKeys: String, CodingKey {
        case genres
    }
}

struct ListNameOfGenre: Decodable {
    let id: Int
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name
    }
}
