import Foundation
import UIKit

final class PeopleDetailViewMirror: MirrorObject {
    init(peopleDetail: PeopleDetailViewController) {
        super.init(refrecting: peopleDetail)
    }
    
    var castNameLabel: UILabel? {
        return extract()
    }
    
    var castDepartmentLabel: UILabel? {
        return extract()
    }
    
    var castGenderLabel: UILabel? {
        return extract()
    }
    
    var castBirthLabel: UILabel? {
        return extract()
    }
    
    var castBiography: UILabel? {
        return extract()
    }
    
    var knownForCollectionView: UICollectionView? {
        return extract()
    }
    
}
