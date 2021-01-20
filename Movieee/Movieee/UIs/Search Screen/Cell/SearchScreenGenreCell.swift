import UIKit
class SearchScreenGenreCell: UICollectionViewCell {
    @IBOutlet private weak var genreName: UILabel!
    
    func configGenreCell(genreId: Int) {
        genreName.text = GenreList(rawValue: genreId)?.genreName
    }
}
