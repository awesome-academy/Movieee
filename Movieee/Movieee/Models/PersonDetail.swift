import Foundation

struct PersonDetail: Decodable {
    let id: Int
    let name: String
    let image: String
    let department: String
    let gender: Int
    let birthday: String
    let biography: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name, gender, birthday, biography
        case image = "profile_path"
        case department = "known_for_department"
    }
}
