import UIKit
final class WelcomeScreenViewController: UIViewController {
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    @IBAction func getStartedButton(_ sender: UIButton) {
        UserDefaults.standard.set(true,
                                  forKey: KeyUserDefault.keyCheckNewUser)
        navigationToHomeScreen()
    }
    
    private func navigationToHomeScreen() {
        let homeStoryboard = UIStoryboard(name: IdStoryboard.home,
                                          bundle: nil)
        guard let homeVC = homeStoryboard.instantiateViewController(withIdentifier: IdViewController.home) as? HomeScreenViewController
        else { return }
        
        UIApplication.shared.windows.first?.rootViewController = homeVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
