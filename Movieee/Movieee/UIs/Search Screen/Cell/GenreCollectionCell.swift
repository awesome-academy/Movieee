import UIKit
final class GenreCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var genreName: UILabel!
    
    func configGenreCell(list: ListNameOfGenre) {
        genreName.text = list.name
    }
}
