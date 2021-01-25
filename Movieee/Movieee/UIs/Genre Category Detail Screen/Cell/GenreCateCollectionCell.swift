import UIKit
final class GenreCateCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var moviePosterImageView: UIImageView!
    @IBOutlet private weak var movieNameLabel: UILabel!
    private var id = 0
    
    func configCell(movieList: ListMovieNameAndPoster) {
        if let moviePoster = movieList.poster {
            moviePosterImageView.getImageFromURL(imgURL: UrlAPIMovie.urlMovieImage + moviePoster)
        }
        movieNameLabel.text = movieList.title
        id = movieList.id
    }
}
