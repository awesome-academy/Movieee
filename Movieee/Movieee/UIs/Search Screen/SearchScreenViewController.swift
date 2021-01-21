import UIKit
private enum ConstraintsSearchScreen {
    static let idListFilmTableCell = "ListFilmTableCell"
    static let idMovieGenreCell = "MovieGenreCell"
    static let heightForRowTableView: CGFloat = 210
    static let sizeForGenreItem = CGSize(width: 70, height: 20)
}

enum SearchType {
    case movieName
    case personName
}

class SearchScreenViewController: UIViewController {
    
    @IBOutlet private weak var notFoundView: UIView!
    @IBOutlet private weak var listFilmTableView: UITableView!
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var movieNameLabel: UIButton!
    @IBOutlet private weak var personNameLabel: UIButton!
    
    var searchType = SearchType.movieName
    var listFilmByMovieName = [MovieSearchResults]() {
        didSet {
            listFilmTableView.reloadData()
        }
    }
    var knownForPersonSearch = [PersonSearchResult]()
    var listFilmByPersonName = [MovieKnownForInPersonSearch]() {
        didSet {
            listFilmTableView.reloadData()
        }
    }
    var idForMovieDetail = 0
    var listGenres = [Genres]()
    private var storedOffsets = [Int: CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listFilmTableView.delegate = self
        listFilmTableView.dataSource = self
        searchField.delegate = self
        listFilmTableView.backgroundView = notFoundView
        notFoundView.isHidden = true
    }
    
    private func configSearchScreen(key: String) {
        listFilmByMovieName.removeAll()
        knownForPersonSearch.removeAll()
        listFilmByPersonName.removeAll()
        APIMovie.apiMovie.getGenreList { [unowned self] (genres) in
            if let genres = genres {
                listGenres = genres.genres
                getDataSearch(key: key)
            }
        }
    }
    
    private func getDataSearch(key: String) {
        if searchType == .movieName {
            APIMovie.apiMovie.getMovieFromSearchByMovieName(with: key) { [unowned self] results in
                if let results = results {
                    listFilmByMovieName = results.results
                }
                notFoundView.isHidden = !listFilmByMovieName.isEmpty
            }
        } else {
            APIMovie.apiMovie.getMovieFromSearchByPersonName(with: key) { [unowned self] results in
                if let results = results {
                    knownForPersonSearch = results.results
                    listFilmByPersonName = knownForPersonSearch.map { $0.knownFor[0] }
                    listFilmByPersonName = listFilmByPersonName.filter { $0.title != nil }
                }
                notFoundView.isHidden = !listFilmByPersonName.isEmpty
            }
        }
    }
    
    @IBAction func movieNamePressed(_ sender: UIButton) {
        searchType = .movieName
        movieNameLabel.setTitleColor(.white, for: .normal)
        personNameLabel.setTitleColor(.gray, for: .normal)
        searchField.text = ""
        listFilmTableView.reloadData()
    }
    
    @IBAction func peopleNamePressed(_ sender: Any) {
        searchType = .personName
        movieNameLabel.setTitleColor(.gray, for: .normal)
        personNameLabel.setTitleColor(.white, for: .normal)
        searchField.text = ""
        listFilmTableView.reloadData()
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchField.endEditing(true)
        configSearchScreen(key: searchField.text ?? "")
        listFilmTableView.reloadData()
    }
    
    @IBAction func goBackPreviousView(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: - Textfield
extension SearchScreenViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        configSearchScreen(key: searchField.text ?? "")
        listFilmTableView.reloadData()
        return true
    }
}
//MARK: - TableView
extension SearchScreenViewController: UITableViewDelegate,
                                      UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return searchType == .movieName ? listFilmByMovieName.count : listFilmByPersonName.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConstraintsSearchScreen.idListFilmTableCell,
                                                       for: indexPath) as? SearchScreenTableViewCell
        else { return UITableViewCell() }
        
        if searchType == .movieName {
            cell.configCellByMovie(movieSearch: listFilmByMovieName[indexPath.row])
        } else {
            cell.configCellByPerson(personSearch: listFilmByPersonName[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ConstraintsSearchScreen.heightForRowTableView
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? SearchScreenTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self,
                                                          forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   didEndDisplaying cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? SearchScreenTableViewCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if searchType == .movieName {
            idForMovieDetail = listFilmByMovieName[indexPath.row].id
        } else {
            idForMovieDetail = listFilmByPersonName[indexPath.row].id
        }
        //Navigation to Movie Detail Screen
        //Use idForMovieDetail to pass data
    }
}

//MARK: - GenreCell - CollectionViewCell
extension SearchScreenViewController: UICollectionViewDelegate,
                                      UICollectionViewDataSource,
                                      UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        
        return searchType == .movieName ? listFilmByMovieName[collectionView.tag].genres.count : listFilmByPersonName[collectionView.tag].genres.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstraintsSearchScreen.idMovieGenreCell,
                                                            for: indexPath) as? GenreCollectionCell
        else { return UICollectionViewCell() }
        
        if searchType == .movieName {
            let indexGenres = listGenres.firstIndex { (element) -> Bool in
                element.id == listFilmByMovieName[collectionView.tag].genres[indexPath.row]
            } ?? 0
            cell.configGenreCell(list: listGenres[indexGenres])
        } else {
            let indexGenres = listGenres.firstIndex { (element) -> Bool in
                element.id == listFilmByPersonName[collectionView.tag].genres[indexPath.row]
            } ?? 0
            cell.configGenreCell(list: listGenres[indexGenres])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ConstraintsSearchScreen.sizeForGenreItem
    }
}

