import Foundation
import CoreData


extension FavoriteModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteModel> {
        return NSFetchRequest<FavoriteModel>(entityName: "FavoriteModel")
    }

    @NSManaged public var id: Int32
    @NSManaged public var voteAverage: Double
    @NSManaged public var overview: String?
    @NSManaged public var poster: String?
    @NSManaged public var title: String?

}
