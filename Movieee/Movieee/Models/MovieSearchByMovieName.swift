import Foundation

struct MovieSearchByMovieName: Decodable {
    let results: [MovieSearchResults]
    
    private enum CodingKeys: String, CodingKey {
        case results
    }
}

struct MovieSearchResults: Decodable {
    let id: Int
    let title: String
    let poster: String
    let genres: [Int]
    let voteAverage: Double
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title = "original_title"
        case poster = "poster_path"
        case genres = "genre_ids"
        case voteAverage = "vote_average"
    }
}
