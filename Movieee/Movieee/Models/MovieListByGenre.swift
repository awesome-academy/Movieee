import Foundation

struct MovieListByGenre: Decodable {
    let results: [GenreResult]
    
    private enum CodingKeys: String, CodingKey {
        case results
    }
}

struct GenreResult: Decodable {
    let title: String
    let poster: String?
    
    private enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case poster = "poster_path"
    }
}
