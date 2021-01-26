import UIKit

final class FavoriteScreenTableCell: UITableViewCell {
    
    @IBOutlet private var ratingStars: [UIImageView]!
    @IBOutlet private weak var voteRate: UILabel!
    @IBOutlet private weak var movieOverview: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var filmNameLabel: UILabel!
    private var filmId = 0
    private var voteAverage = 0.0
    
    func configCell(listItem: FavoriteModel) {
        filmNameLabel.text = listItem.title
        movieOverview.text = listItem.overview
        if let itemPoster = listItem.poster {
            posterImageView.getImageFromURL(imgURL: UrlAPIMovie.urlMovieImage + itemPoster)
        }
        filmId = Int(listItem.id)
        voteAverage = listItem.voteAverage
        configStarBar(rate: listItem.voteAverage)
    }
    
    func configStarBar(rate: Double) {
        voteRate.text = "\(rate)"
        let numStar = Int(rate / 2)
        for index in 0..<ratingStars.count {
            ratingStars[index].tintColor = index < numStar ? .systemYellow : .lightGray
        }
    }
    
}
