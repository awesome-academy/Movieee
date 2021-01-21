import UIKit
class SearchScreenTableViewCell: UITableViewCell {
    
    @IBOutlet private var ratingStars: [UIImageView]!
    @IBOutlet private weak var voteRate: UILabel!
    
    @IBOutlet private weak var genreCollectionView: UICollectionView!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var filmNameLabel: UILabel!
    var filmId = 0
    var genreList = [Int]()
    var voteAverage = 0.0
    
    func configCellByMovie(movieSearch: MovieSearchResults) {
        filmNameLabel.text = movieSearch.title
        posterImageView.getImageFromURL(imgURL: UrlAPIMovie.urlMovieImage + movieSearch.poster)
        filmId = movieSearch.id
        genreList = movieSearch.genres
        voteAverage = movieSearch.voteAverage
        configStarBar(rate: movieSearch.voteAverage)
    }
    
    func configStarBar(rate: Double) {
        voteRate.text = "\(rate)"
        let numStar = Int(rate / 2)
        for index in 0..<ratingStars.count {
            ratingStars[index].tintColor = index < numStar ? .systemYellow : .lightGray
        }
    }
    
    func configCellByPerson(personSearch: MovieKnownForInPersonSearch) {
        filmNameLabel.text = personSearch.title
        posterImageView.getImageFromURL(imgURL: UrlAPIMovie.urlMovieImage + personSearch.poster)
        filmId = personSearch.id
        genreList = personSearch.genres
        voteAverage = personSearch.voteAverage
        configStarBar(rate: personSearch.voteAverage)
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate,
                                             forRow row: Int) {
        genreCollectionView.delegate = dataSourceDelegate
        genreCollectionView.dataSource = dataSourceDelegate
        genreCollectionView.tag = row
        genreCollectionView.reloadData()
    }

    var collectionViewOffset: CGFloat {
        set { genreCollectionView.contentOffset.x = newValue }
        get { return genreCollectionView.contentOffset.x }
    }
}
