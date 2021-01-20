import Foundation

enum GenreList : Int {
    case adventure = 12
    case fantasy = 14
    case animation = 16
    case drama = 18
    case horror = 27
    case action = 28
    case comedy = 35
    case history = 36
    case western = 37
    case thriller = 53
    case crime = 80
    case documentary = 99
    case scifi = 878
    case mystery = 9648
    case family = 10751
    case music = 10402
    case romance = 10749
    case tvMovie = 10770
    case war = 10752
    
    var genreName: String {
        switch self {
        case .adventure: return "Adventure"
        case .fantasy: return "Fantasy"
        case .animation: return "Animation"
        case .drama: return "Drama"
        case .horror: return "Horror"
        case .action: return "Action"
        case .comedy: return "Comedy"
        case .history: return "History"
        case .western: return "Western"
        case .thriller: return "Thriller"
        case .crime: return "Crime"
        case .documentary: return "Document"
        case .scifi: return "Sci-fi"
        case .mystery: return "Mystery"
        case .family: return "Family"
        case .music: return "Music"
        case .romance: return "Romance"
        case .tvMovie: return "TV Movie"
        case .war: return "War"
        }
    }
}
