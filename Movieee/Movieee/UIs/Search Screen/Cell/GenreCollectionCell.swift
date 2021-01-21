import UIKit
final class GenreCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var genreName: UILabel!
    
    func configGenreCell(list: Genres) {
        genreName.text = list.name
    }
}
