import UIKit
final class HomeScreenTableCell: UITableViewCell {
    
    @IBOutlet private weak var homeScreenCollectionView: UICollectionView!
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate,
                                             forRow row: Int) {
        homeScreenCollectionView.delegate = dataSourceDelegate
        homeScreenCollectionView.dataSource = dataSourceDelegate
        homeScreenCollectionView.tag = row
        homeScreenCollectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { homeScreenCollectionView.contentOffset.x = newValue }
        get { return homeScreenCollectionView.contentOffset.x }
    }
}
