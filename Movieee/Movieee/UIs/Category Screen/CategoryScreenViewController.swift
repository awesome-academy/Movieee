import UIKit
private enum CategoryConstraints {
    static let idCategoryTableCell = "CategoryScreenTableCell"
    static let heightForRowTableView: CGFloat = 175
    
    enum KindOfCategoryURL: String, CaseIterable {
        case popular = "popular"
        case nowPlaying = "now_playing"
        case upComing = "upcoming"
        case topRated = "top_rated"
        var labelName: String {
            switch self {
            case .popular: return "POPULAR"
            case .nowPlaying: return "NOW PLAYING"
            case .upComing: return "UP COMING"
            case .topRated: return "TOP RATED"
            }
        }
    }
}

final class CategoryScreenViewController: UIViewController {
    
    @IBOutlet private weak var categoryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        let searchStoryboard = UIStoryboard(name: IdStoryboard.search, bundle: nil)
        guard let searchVC = searchStoryboard.instantiateViewController(
                withIdentifier: IdViewController.search)
                as? SearchScreenViewController else { return }
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}
//MARK: - TableView
extension CategoryScreenViewController: UITableViewDelegate,
                                        UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return CategoryConstraints.KindOfCategoryURL.allCases.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryConstraints.idCategoryTableCell,
                                                       for: indexPath) as? CategoryTableCell
        else { return UITableViewCell() }
        cell.configCell(name: CategoryConstraints.KindOfCategoryURL.allCases[indexPath.row].labelName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CategoryConstraints.heightForRowTableView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let keyToPass = CategoryConstraints.KindOfCategoryURL.allCases[indexPath.row].rawValue
        let categoryName = CategoryConstraints.KindOfCategoryURL.allCases[indexPath.row].labelName
        let genreCateStoryboard = UIStoryboard(name: IdStoryboard.genreCate, bundle: nil)
        guard let genreCateVC = genreCateStoryboard.instantiateViewController(
                withIdentifier: IdViewController.genreCate)
                as? GenreCateScreenViewController else { return }
    
        self.navigationController?.pushViewController(genreCateVC, animated: true)
        genreCateVC.categoryType = keyToPass
        genreCateVC.categoryName = categoryName
        genreCateVC.viewType = .category
    }
}
