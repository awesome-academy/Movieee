import Foundation

struct MovieSearchByPersonName: Decodable {
    let results: [PersonSearchResult]
    
    private enum CodingKeys: String, CodingKey {
        case results
    }
}

struct PersonSearchResult: Decodable {
    let knownFor: [MovieKnownForInPersonSearch]
    
    private enum CodingKeys: String, CodingKey {
        case knownFor = "known_for"
    }
}

struct MovieKnownForInPersonSearch: Decodable {
    let id: Int
    let title: String?
    let genres: [Int]
    let poster: String
    let voteAverage: Double
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title = "original_title"
        case poster = "poster_path"
        case genres = "genre_ids"
        case voteAverage = "vote_average"
    }
}
