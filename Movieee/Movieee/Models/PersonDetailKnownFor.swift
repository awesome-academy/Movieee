import Foundation

struct PersonDetailKnownFor: Decodable {
    let id: Int
    let cast: [ListMovieNameAndPoster]
    
    private enum CodingKeys: String, CodingKey {
        case id, cast
    }
}

extension PersonDetailKnownFor: Equatable {
    static func == (lhs: PersonDetailKnownFor,
                    rhs: PersonDetailKnownFor) -> Bool {
        return lhs.id == rhs.id
            && lhs.cast == rhs.cast
    }
}
