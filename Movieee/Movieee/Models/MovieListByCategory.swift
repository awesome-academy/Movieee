import Foundation

struct MovieListByCategory: Decodable {
    let results: [CategoryResults]
    
    private enum CodingKeys: String, CodingKey {
        case results
    }
}

struct CategoryResults: Decodable {
    let id: Int
    let title: String
    let poster: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title = "original_title"
        case poster = "poster_path"
    }
}
