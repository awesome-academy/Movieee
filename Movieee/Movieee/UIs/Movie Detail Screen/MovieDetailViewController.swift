import UIKit
import CoreData

private enum ConstraintsMovieDetail {
    static let idGenreCell = "GenreCollectionCell"
    static let idCastCell = "CastCollectionCell"
    static let sizeOfItem = CGSize(width: 100, height: 200)
}

final class MovieDetailViewController: UIViewController {
    @IBOutlet private weak var loveButtonOutlet: UIButton!
    @IBOutlet private weak var posterImage: UIImageView!
    @IBOutlet private weak var filmNameLabel: UILabel!
    @IBOutlet private weak var filmDuration: UILabel!
    @IBOutlet private weak var filmReleaseDay: UILabel!
    @IBOutlet private weak var filmDescription: UILabel!
    @IBOutlet private weak var voteRate: UILabel!
    @IBOutlet private weak var genreCollection: UICollectionView!
    @IBOutlet private weak var castCollection: UICollectionView!
    @IBOutlet private var ratingStars: [UIImageView]!
    
    var idFilm = 0
    private var items = [FavoriteModel]()
    private var isMovieHasFavorited = false
    private let dispatchGroup = DispatchGroup()
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    private var movieDetail: MovieDetail? {
        didSet {
            genreCollection.reloadData()
        }
    }
    private var castMovieDetail = [CastInMovieDetail]() {
        didSet {
            castCollection.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genreCollection.delegate = self
        castCollection.delegate = self
        genreCollection.dataSource = self
        castCollection.dataSource = self
        configMovieDetail(with: idFilm)
        isMovieHasFavorited = checkItem()
    }
    
    private func configMovieDetail(with id: Int) {
        dispatchGroup.enter()
        APIMovie.apiMovie.getMovieDetail(movieId: String(id)) { [unowned self] result in
            if let result = result {
                movieDetail = result
                configInfo(movieInfo: result)
            }
        }
        APIMovie.apiMovie.getMovieCredits(movieId: String(id)) { [unowned self] result in
            if let result = result {
                castMovieDetail = result.cast
            }
        }
        dispatchGroup.leave()
    }
    
    private func configInfo(movieInfo: MovieDetail) {
        posterImage.getImageFromURL(imgURL: UrlAPIMovie.urlMovieImage + movieInfo.poster)
        filmNameLabel.text = movieInfo.title
        filmDuration.text = "\(movieInfo.runtime / 60)h \(movieInfo.runtime % 60)m"
        filmDescription.text = movieInfo.overview
        filmReleaseDay.text = movieInfo.releaseDay
        voteRate.text = "\(movieInfo.voteAverage)"
        configStarBar(rate: movieInfo.voteAverage)
    }
    
    private func configStarBar(rate: Double) {
        voteRate.text = "\(rate)"
        let numStar = Int(rate / 2)
        for index in 0..<ratingStars.count {
            ratingStars[index].tintColor = index < numStar ? .systemYellow : .lightGray
        }
    }
    
    @IBAction func viewTrailerPressed(_ sender: UIButton) {
        let trailerDetailStoryboard = UIStoryboard(name: IdStoryboard.trailerDetail, bundle: nil)
        guard let trailerDetailVC = trailerDetailStoryboard.instantiateViewController(
                withIdentifier: IdViewController.trailerDetail)
                as? TrailerDetailViewController else { return }
        self.navigationController?.pushViewController(trailerDetailVC, animated: true)
        trailerDetailVC.idFilm = idFilm
    }
    
    @IBAction func likeButtonPressed(_ sender: UIButton) {
        guard let movieInfo = movieDetail
        else { return }
        if let context = appDelegate?.persistentContainer.viewContext {
            if isMovieHasFavorited  {
                let newFavoriteMovie = FavoriteModel(context: context)
                newFavoriteMovie.id = Int32(movieInfo.id)
                newFavoriteMovie.poster = movieInfo.poster
                newFavoriteMovie.title = movieInfo.title
                newFavoriteMovie.voteAverage = movieInfo.voteAverage
                newFavoriteMovie.overview = movieInfo.overview
                sender.backgroundColor = .systemPink
                isMovieHasFavorited = false
            } else {
                deleteItem()
                sender.backgroundColor = UIColor(named: ColorName.loveBackgroundColorName)
                isMovieHasFavorited = true
            }
        }
        saveItem()
    }
    
    private func checkItem() -> Bool {
        let request: NSFetchRequest<FavoriteModel> = FavoriteModel.fetchRequest()
        request.predicate = NSPredicate(format: "id == %i", idFilm)
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        let context = appDelegate?.persistentContainer.viewContext
        do {
            items = try context?.fetch(request) ?? [FavoriteModel]()
        } catch {
            print("Error fetching data \(error)")
        }
        if items.isEmpty {
            loveButtonOutlet.backgroundColor = UIColor(named: ColorName.loveBackgroundColorName)
            return true
        } else {
            loveButtonOutlet.backgroundColor = .systemPink
            return false
        }
    }
    
    private func saveItem() {
        let context = appDelegate?.persistentContainer.viewContext
        do {
            try context?.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    private func deleteItem() {
        let request: NSFetchRequest<FavoriteModel> = FavoriteModel.fetchRequest()
        request.predicate = NSPredicate(format: "id == \(idFilm)")
        let context = appDelegate?.persistentContainer.viewContext
        do {
            items = try context?.fetch(request) ?? [FavoriteModel]()
        } catch {
            print("Error fetching data \(error)")
        }
        for item in items {
            context?.delete(item)
        }
        saveItem()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: - Genre, Cast CollectionView
extension MovieDetailViewController: UICollectionViewDelegate,
                                     UICollectionViewDataSource,
                                     UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if collectionView == genreCollection {
            return movieDetail?.genres.count ?? 0
        } else {
            return castMovieDetail.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == genreCollection {
            guard let genreCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstraintsMovieDetail.idGenreCell,
                                                                     for: indexPath) as? MovieDetailGenreCollectionCell,
                  let genre = movieDetail?.genres[indexPath.row]
            else { return UICollectionViewCell() }
            
            genreCell.configMovieGenreCell(movieDetailGenre: genre)
            return genreCell
        } else {
            guard let castCell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstraintsMovieDetail.idCastCell ,
                                                                    for: indexPath) as? CastCollectionCell
            else { return UICollectionViewCell() }
            
            castCell.configCastCell(castList: castMovieDetail[indexPath.row])
            return castCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ConstraintsMovieDetail.sizeOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == genreCollection {
            let genreInfo = movieDetail?.genres[indexPath.row]
            let genreCateStoryboard = UIStoryboard(name: IdStoryboard.genreCate, bundle: nil)
            guard let genreCateVC = genreCateStoryboard.instantiateViewController(
                    withIdentifier: IdViewController.genreCate)
                    as? GenreCateScreenViewController else { return }
            
            self.navigationController?.pushViewController(genreCateVC, animated: true)
            genreCateVC.genreInfo = genreInfo
            genreCateVC.viewType = .genre
        } else {
            let idCast = castMovieDetail[indexPath.row].id
            let peopleDetailStoryboard = UIStoryboard(name: IdStoryboard.peopleDetail, bundle: nil)
            guard let peopleDetailVC = peopleDetailStoryboard.instantiateViewController(
                    withIdentifier: IdViewController.peopleDetail)
                    as? PeopleDetailViewController else { return }
            
            self.navigationController?.pushViewController(peopleDetailVC, animated: true)
            peopleDetailVC.personId = idCast
        }
    }
}
