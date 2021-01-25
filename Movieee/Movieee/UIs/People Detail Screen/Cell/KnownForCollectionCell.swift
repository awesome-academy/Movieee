import UIKit
final class KnownForCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var movieImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    private var id = 0
    
    func configCell(movieList: ListMovieNameAndPoster) {
        if let moviePoster = movieList.poster {
            movieImageView.getImageFromURL(imgURL: UrlAPIMovie.urlMovieImage + moviePoster)
        }
        movieNameLabel.text = movieList.title
        id = movieList.id
    }
}
