import Foundation

struct PersonDetailKnownFor: Decodable {
    let id: Int
    let cast: [ListMovieNameAndPoster]
    
    private enum CodingKeys: String, CodingKey {
        case id, cast
    }
}
