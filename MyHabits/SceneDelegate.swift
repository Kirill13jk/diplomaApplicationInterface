import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
      
        let habitsViewController = HabitsViewController()
        habitsViewController.title = "Привычки"
        
        let infoViewController = InfoViewController()
        infoViewController.title = "Информация"
        
        let tabBarController = UITabBarController()
        tabBarController.tabBar.barTintColor = .systemGray5
        tabBarController.tabBar.tintColor = .purple
        
        habitsViewController.tabBarItem = UITabBarItem(title: "Привычки", image: UIImage(systemName: "list.bullet"), tag: 0)
        infoViewController.tabBarItem = UITabBarItem(title: "Информация", image: UIImage(systemName: "info.circle"), tag: 1)
        
        let controllers = [habitsViewController, infoViewController]
        tabBarController.viewControllers = controllers.map {
            UINavigationController(rootViewController: $0)
        }
        
        tabBarController.selectedIndex = 0
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) { }

    func sceneDidBecomeActive(_ scene: UIScene) { }

    func sceneWillResignActive(_ scene: UIScene) { }

    func sceneWillEnterForeground(_ scene: UIScene) { }

    func sceneDidEnterBackground(_ scene: UIScene) { }
}
