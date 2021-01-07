import Foundation

struct MovieDetailCredits: Decodable {
    let id: Int
    let cast: [CastInMovieDetail]
    
    private enum CodingKeys: String, CodingKey {
        case id, cast
    }
}

struct CastInMovieDetail: Decodable {
    let id: Int
    let name: String
    let image: String?
    
    private enum CodingKeys: String, CodingKey {
        case id, name
        case image = "profile_path"
    }
}
