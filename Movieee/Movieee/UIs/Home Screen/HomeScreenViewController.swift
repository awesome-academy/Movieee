import UIKit
private enum HomeConstraints {
    static let heightForRowOfTableView: CGFloat = 310
    static let heightForHeaderTableView: CGFloat = 36
    static let heightForHeaderViewTableView: CGFloat = 50
    static let labelHeaderFontSize: CGFloat = 16
    static let labelHeaderSpacing: CGFloat = 10
    static let sizeOfItem = CGSize(width: 150, height: 280)
    static let idHomeTableView = "HomeScreenCategoryCell"
    static let idHomeCollectionView = "HomeScreenMovieListCell"
    
    enum KindOfCategory: String, CaseIterable {
        case popular = "popular"
        case nowPlaying = "now_playing"
        case upComing = "upcoming"
        case topRated = "top_rated"
        var headerTitle: String {
            switch self {
            case .popular: return "POPULAR"
            case .nowPlaying: return "NOW PLAYING"
            case .upComing: return "UPCOMING"
            case .topRated: return "TOP RATED"
            }
        }
    }
}

final class HomeScreenViewController: UIViewController {
    
    @IBOutlet weak private var homeScreenTableView: UITableView!
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        let searchStoryboard = UIStoryboard(name: IdStoryboard.search, bundle: nil)
        guard let searchVC = searchStoryboard.instantiateViewController(
                withIdentifier: IdViewController.search)
                as? SearchScreenViewController else { return }
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
    
    private var data = [HomeConstraints.KindOfCategory: [CategoryResults]]()
    private var listFilmByCategory = [CategoryResults]()
    private var storedOffsets = [Int: CGFloat]()
    private var idForMovieDetail = 0
    private let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeScreenTableView.delegate = self
        homeScreenTableView.dataSource = self
        
        for index in 0..<HomeConstraints.KindOfCategory.allCases.count {
            configHomeScreen(category: HomeConstraints.KindOfCategory.allCases[index])
        }
        
        dispatchGroup.notify(queue: .main) {
            self.homeScreenTableView.reloadData()
        }
    }
    
    private func configHomeScreen(category: HomeConstraints.KindOfCategory) {
        dispatchGroup.enter()
        APIMovie.apiMovie.getMovieFromCategory(from: category.rawValue) { [unowned self] result in
            if let result = result {
                data[category] = result.results
                dispatchGroup.leave()
            }
        }
    }
    
    private func configListFilmByCategory(list: [CategoryResults]) {
        listFilmByCategory = list
    }
    
}
//MARK: - TableView
extension HomeScreenViewController: UITableViewDelegate,
                                    UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeConstraints.idHomeTableView,
                                                 for: indexPath) as? HomeScreenCategoryCell
        else { return UITableViewCell() }
        configListFilmByCategory(
            list: data[HomeConstraints.KindOfCategory.allCases[indexPath.section]] ?? [CategoryResults]())
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return HomeConstraints.heightForRowOfTableView
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        return HomeConstraints.heightForHeaderTableView
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect.init(x: 0, y: 0,
                                                   width: tableView.frame.width,
                                                   height: HomeConstraints.heightForHeaderViewTableView))
        headerView.backgroundColor = UIColor(named: ColorName.backgroundColorName)
        
        let label = UILabel()
        label.frame = CGRect(x: 24, y: 0,
                             width: headerView.frame.width - HomeConstraints.labelHeaderSpacing,
                             height: headerView.frame.height - HomeConstraints.labelHeaderSpacing)
        label.text = HomeConstraints.KindOfCategory.allCases[section].headerTitle
        label.font = UIFont(name: FontName.HelveticaNeueBoldName,
                            size: HomeConstraints.labelHeaderFontSize)
        label.textColor = UIColor.white
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? HomeScreenCategoryCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self,
                                                          forRow: indexPath.row)
        tableViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   didEndDisplaying cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? HomeScreenCategoryCell else { return }
        storedOffsets[indexPath.row] = tableViewCell.collectionViewOffset
    }
}
//MARK: - CollectionView
extension HomeScreenViewController: UICollectionViewDelegate,
                                    UICollectionViewDataSource,
                                    UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return listFilmByCategory.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =
                collectionView.dequeueReusableCell(withReuseIdentifier: HomeConstraints.idHomeCollectionView,
                                                   for: indexPath) as? HomeScreenMovieListCell
        else { return UICollectionViewCell() }
        cell.configCell(movie: listFilmByCategory[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return HomeConstraints.sizeOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let filmInfo = listFilmByCategory[indexPath.row]
        idForMovieDetail = filmInfo.id
        //navigation to Movie Detail Screen
        //Use idForMovieDetail to pass data to Movie Detail Screen
    }
}
