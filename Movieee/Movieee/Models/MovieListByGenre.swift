import Foundation

struct MovieListByGenre: Decodable {
    let results: [ListMovieNameAndPoster]
    
    private enum CodingKeys: String, CodingKey {
        case results
    }
}
