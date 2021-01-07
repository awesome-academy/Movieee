import UIKit

class WelcomeScreenViewController: UIViewController {

    @IBOutlet weak var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStartedButton.layer.cornerRadius = 20
    }
    
    @IBAction func getStartedButton(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "hasLaunched")
        performSegue(withIdentifier: "toMainScreenSegue", sender: self)
    }
    
}
