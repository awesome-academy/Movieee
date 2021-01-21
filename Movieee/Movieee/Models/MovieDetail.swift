import Foundation

struct MovieDetail: Decodable {
    let id: Int
    let title: String
    let poster: String
    let overview: String
    let genres: [GenresOfMovie]
    let voteAverage: Double
    let runtime: Int
    let releaseDay: String
    
    private enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case poster = "poster_path"
        case id, overview, genres, runtime
        case voteAverage = "vote_average"
        case releaseDay = "release_date"
    }
}

struct GenresOfMovie: Decodable {
    let id: Int
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name
    }
}
