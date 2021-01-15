import UIKit
final class CategoryTableCell: UITableViewCell {

    @IBOutlet private weak var categoryName: UILabel!
    @IBOutlet private weak var cellImage: UIImageView!
    
    func configCell(name: String) {
        categoryName.text = name
    }
}
