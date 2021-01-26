import UIKit
import CoreData

private enum ConstraintsFavoriteScreen {
    static let idListFilmTableCell = "FavoriteScreenTableCell"
    static let idMovieGenreCell = "FavoriteGenreCollectionCell"
    static let trashImageName = "trash"
    static let pointSizeTrashImage: CGFloat = 40
    static let heightForRowTableView: CGFloat = 210
    static let sizeForGenreItem = CGSize(width: 70, height: 20)
}

final class FavoriteScreenViewController: UIViewController {
    @IBOutlet private weak var listFilmTableView: UITableView!
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private var item = [FavoriteModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listFilmTableView.delegate = self
        listFilmTableView.dataSource = self
        loadMovies()
        
        let refreshControl = UIRefreshControl()
        let color = [NSAttributedString.Key.foregroundColor : UIColor.white]
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Movies",
                                                            attributes: color)
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        listFilmTableView.refreshControl = refreshControl
    }
    
    @objc private func refresh(refreshControl: UIRefreshControl) {
        loadMovies()
        listFilmTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    private func loadMovies() {
        let context = appDelegate?.persistentContainer.viewContext
        let request: NSFetchRequest<FavoriteModel> = FavoriteModel.fetchRequest()
        do {
            item = try context?.fetch(request) ?? [FavoriteModel]()
        } catch {
            print("Error fetching data \(error)")
        }
    }
    
    private func saveMovies() {
        let context = appDelegate?.persistentContainer.viewContext
        do {
            try context?.save()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    private func deleteMovies(at indexPath: IndexPath) -> UIContextualAction {
        let context = appDelegate?.persistentContainer.viewContext
        let action = UIContextualAction(style: .destructive,
                                        title: "") { [unowned self] (action, view, completion) in
            context?.delete(item[indexPath.row])
            item.remove(at: indexPath.row)
            listFilmTableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        let configuration = UIImage.SymbolConfiguration(pointSize: ConstraintsFavoriteScreen.pointSizeTrashImage)
        action.image = UIImage(systemName: ConstraintsFavoriteScreen.trashImageName,
                               withConfiguration: configuration)
        action.backgroundColor = UIColor(named: ColorName.itemForegroundColorName)
        saveMovies()
        return action
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        let searchStoryboard = UIStoryboard(name: IdStoryboard.search, bundle: nil)
        guard let searchVC = searchStoryboard.instantiateViewController(
                withIdentifier: IdViewController.search)
                as? SearchScreenViewController else { return }
        self.navigationController?.pushViewController(searchVC, animated: true)
    }
}
//MARK: - ListFilm TableView
extension FavoriteScreenViewController: UITableViewDelegate,
                                        UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConstraintsFavoriteScreen.idListFilmTableCell,
                                                       for: indexPath) as? FavoriteScreenTableCell
        else { return UITableViewCell() }
        cell.configCell(listItem: item[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ConstraintsFavoriteScreen.heightForRowTableView
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteMovies(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let idFilm = item[indexPath.row].id
        let movieDetailStoryboard = UIStoryboard(name: IdStoryboard.movieDetail, bundle: nil)
        guard let movieDetailVC = movieDetailStoryboard.instantiateViewController(
                withIdentifier: IdViewController.movieDetail)
                as? MovieDetailViewController else { return }
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
        movieDetailVC.idFilm = Int(idFilm)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
