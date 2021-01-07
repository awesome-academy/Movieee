import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let rvc = self.window?.rootViewController {
            let ud = UserDefaults.standard
            if ud.bool(forKey: "hasLaunched") == true {
                print("Not the first time")
                let vc = rvc.storyboard!.instantiateViewController(withIdentifier: "TabbarViewController")
                self.window!.rootViewController = vc
            }
        }
    }
    
}
