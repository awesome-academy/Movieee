import UIKit
class SearchScreenTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var star1: UIImageView!
    @IBOutlet private weak var star2: UIImageView!
    @IBOutlet private weak var star3: UIImageView!
    @IBOutlet private weak var star4: UIImageView!
    @IBOutlet private weak var star5: UIImageView!
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
        let stars = [star1, star2, star3, star4, star5]
        for index in 0..<stars.count {
            stars[index]?.tintColor = index < numStar ? .systemYellow : .lightGray
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
