import UIKit
private enum ConstraintsPeopleDetail {
    static let idKnownForCell = "KnownForCollectionCell"
    static let sizeOfItem = CGSize(width: 100, height: 200)
}

final class PeopleDetailViewController: UIViewController {
    @IBOutlet private weak var castImageView: UIImageView!
    @IBOutlet private weak var castNameLabel: UILabel!
    @IBOutlet private weak var castDepartmentLabel: UILabel!
    @IBOutlet private weak var castGenderLabel: UILabel!
    @IBOutlet private weak var castBirthLabel: UILabel!
    @IBOutlet private weak var castBiography: UILabel!
    @IBOutlet private weak var knownForCollectionView: UICollectionView!
    
    private let dispatchGroup = DispatchGroup()
    private var personDetail: PersonDetail?
    private var movieList = [ListMovieNameAndPoster]() {
        didSet {
            knownForCollectionView.reloadData()
        }
    }
    var personId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        knownForCollectionView.delegate = self
        knownForCollectionView.dataSource = self
        configPeopleDetail(with: personId)
    }
    
    private func configPeopleDetail(with id: Int) {
        dispatchGroup.enter()
        APIMovie.apiMovie.getPersonDetail(personId: String(id)) { [weak self] result in
            if let result = result {
                self?.personDetail = result
                self?.configInfo(personInfo: result)
            }
        }
        APIMovie.apiMovie.getPersonDetailKnownFor(personId: String(id)) { [weak self] result in
            if let result = result {
                self?.movieList = result.cast
            }
        }
        dispatchGroup.leave()
    }
    
    private func configInfo(personInfo: PersonDetail) {
        castImageView.getImageFromURL(imgURL: UrlAPIMovie.urlPersonImage + personInfo.image)
        castNameLabel.text = personInfo.name
        castDepartmentLabel.text = personInfo.department
        castBirthLabel.text = personInfo.birthday
        castBiography.text = personInfo.biography
        castGenderLabel.text = personInfo.gender.name
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK: - KnownFor CollectionView
extension PeopleDetailViewController: UICollectionViewDelegate,
                                      UICollectionViewDataSource,
                                      UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ConstraintsPeopleDetail.idKnownForCell,
                                                            for: indexPath) as? KnownForCollectionCell
        else { return UICollectionViewCell() }
        cell.configCell(movieList: movieList[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ConstraintsPeopleDetail.sizeOfItem
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let idFilm = movieList[indexPath.row].id
        
        let movieDetailStoryboard = UIStoryboard(name: IdStoryboard.movieDetail, bundle: nil)
        guard let movieDetailVC = movieDetailStoryboard.instantiateViewController(
                withIdentifier: IdViewController.movieDetail)
                as? MovieDetailViewController else { return }
        
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
        movieDetailVC.idFilm = idFilm
    }
}
