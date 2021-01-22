import UIKit
final class MovieDetailGenreCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var genreNameLabel: UILabel!
    
    func configMovieGenreCell(movieDetailGenre: GenresOfMovie) {
        genreNameLabel.text = movieDetailGenre.name
    }
}
