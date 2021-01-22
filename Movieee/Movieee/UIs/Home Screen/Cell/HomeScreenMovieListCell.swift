import UIKit
final class HomeScreenMovieListCell: UICollectionViewCell {
    
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    var movieId = 0
    
    func configCell(movie: ListMovieNameAndPoster) {
        nameLabel.text = movie.title
        posterImageView.getImageFromURL(imgURL: UrlAPIMovie.urlMovieImage + movie.poster)
        movieId = movie.id
    }
}
