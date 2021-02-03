import Foundation

struct MovieListByCategory: Decodable {
    let results: [ListMovieNameAndPoster]
    
    private enum CodingKeys: String, CodingKey {
        case results
    }
}

struct ListMovieNameAndPoster: Decodable {
    let id: Int
    let title: String
    let poster: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title = "original_title"
        case poster = "poster_path"
    }
}

extension ListMovieNameAndPoster: Equatable {
    static func == (lhs: ListMovieNameAndPoster,
                    rhs: ListMovieNameAndPoster) -> Bool {
        return lhs.id == rhs.id
            && lhs.poster == rhs.poster
            && lhs.title == rhs.title
    }
}
