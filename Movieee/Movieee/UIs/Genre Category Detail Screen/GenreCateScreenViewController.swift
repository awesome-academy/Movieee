import UIKit

private enum GenreCateConstraints {
    static let sizeOfItem = CGSize(width: 175, height: 300)
    static let idGenreCateCollectionCell = "GenreCateCollectionCell"
}

enum ViewType {
    case genre
    case category
    func configTitle(genre: String, category: String) -> String {
        return self == .genre ? genre : category
    }
}

final class GenreCateScreenViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var genreCateCollectionView: UICollectionView!
    
    private let dispatchGroup = DispatchGroup()
    var viewType = ViewType.genre
    var genreInfo: GenresOfMovie?
    var categoryType = ""
    var categoryName = ""
    
    private var listMovie = [ListMovieNameAndPoster]() {
        didSet {
            genreCateCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genreCateCollectionView.delegate = self
        genreCateCollectionView.dataSource = self
        
        configGenreCate(with: genreInfo?.id ?? 0,
                        with: categoryType)
        titleLabel.text = viewType.configTitle(genre: genreInfo?.name.uppercased() ?? "",
                                               category: categoryName)
    }
    
    private func configGenreCate(with id: Int,
                                 with category: String) {
        dispatchGroup.enter()
        if viewType == .genre {
            APIMovie.apiMovie.getMovieFromGenre(from: String(id)) { [unowned self] result in
                if let result = result {
                    listMovie = result.results
                }
            }
        } else {
            APIMovie.apiMovie.getMovieFromCategory(from: category) { [unowned self] result in
                if let result = result {
                    listMovie = result.results
                }
            }
        }
        dispatchGroup.leave()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: - ListFilm Collection
extension GenreCateScreenViewController: UICollectionViewDelegate,
                                         UICollectionViewDataSource,
                                         UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return listMovie.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCateConstraints.idGenreCateCollectionCell,
                                                            for: indexPath) as? GenreCateCollectionCell
        else { return UICollectionViewCell() }
        cell.configCell(movieList: listMovie[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return GenreCateConstraints.sizeOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let idFilm = listMovie[indexPath.row].id
        let movieDetailStoryboard = UIStoryboard(name: IdStoryboard.movieDetail, bundle: nil)
        guard let movieDetailVC = movieDetailStoryboard.instantiateViewController(
                withIdentifier: IdViewController.movieDetail)
                as? MovieDetailViewController else { return }
        
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
        movieDetailVC.idFilm = idFilm
    }
}
