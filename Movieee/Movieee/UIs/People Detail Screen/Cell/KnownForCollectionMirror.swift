import Foundation
import UIKit

final class KnownForCollectionMirror: MirrorObject {
    init(knownFor: KnownForCollectionCell) {
        super.init(refrecting: knownFor)
    }
    
    var movieNameLabel: UILabel? {
        return extract()
    }
}
