import Foundation

struct PersonDetailKnownFor: Decodable {
    let id: Int
    let cast: [MovieKnownForInPersonDetail]
    
    private enum CodingKeys: String, CodingKey {
        case id, cast
    }
}

struct MovieKnownForInPersonDetail: Decodable {
    let title: String
    let poster: String?
    
    private enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case poster = "poster_path"
    }
}
