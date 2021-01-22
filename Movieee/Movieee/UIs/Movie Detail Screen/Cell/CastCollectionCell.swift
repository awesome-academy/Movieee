import UIKit
final class CastCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var castImageView: UIImageView!
    @IBOutlet private weak var castNameLabel: UILabel!
    var castId = 0
    
    func configCastCell(castList: CastInMovieDetail) {
        if let castImage = castList.image {
            castImageView.getImageFromURL(imgURL: UrlAPIMovie.urlPersonImage + castImage)
        }
        castNameLabel.text = castList.name
        castId = castList.id
    }
}
