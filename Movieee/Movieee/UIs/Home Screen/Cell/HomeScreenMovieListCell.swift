import UIKit
final class HomeScreenMovieListCell: UICollectionViewCell {
    
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    private var movieId = 0
    
    func configCell(movie: ListMovieNameAndPoster) {
        if let moviePoster = movie.poster {
            posterImageView.getImageFromURL(imgURL: UrlAPIMovie.urlMovieImage + moviePoster)
        }
        nameLabel.text = movie.title
        movieId = movie.id
    }
}
