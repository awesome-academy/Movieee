import Foundation

struct PersonDetail: Decodable {
    let id: Int
    let name: String
    let image: String
    let department: String
    let gender: Gender
    let birthday: String
    let biography: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name, gender, birthday, biography
        case image = "profile_path"
        case department = "known_for_department"
    }
    
    enum Gender: Int, Decodable {
        case female = 1
        case male = 2
        var name: String {
            switch self {
                case .male: return "Male"
                case .female: return "Female"
            }
        }
    }
    
}
