//
//  SceneDelegate.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/07/19.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // UIWindowScene이 있을 경우에만 루트 뷰 컨트롤러를 설정합니다.
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // 윈도우 생성
        window = UIWindow(windowScene: windowScene)

        if AuthenticationManager.isUserLoggedIn() {
            // 사용자가 로그인되어 있는 경우 탭바 컨트롤러를 보여줍니다.
            print("첫 로그인 - 탭바뷰를 보여줍니다.")
            let mainTabBarController = MainTabBarController()
            mainTabBarController.setRootViewController()
            self.window?.rootViewController = mainTabBarController
            self.window?.makeKeyAndVisible()
        } else {
            // 사용자가 로그인되어 있지 않은 경우 로그인 뷰 컨트롤러를 보여줍니다.
            print("첫 로그인 - 로그인뷰를 보여줍니다.")
            // 사용자가 로그인하지 않은 경우
            let loginViewController = LoginViewController()
            let navigationController = UINavigationController(rootViewController: loginViewController)
            window?.rootViewController = navigationController
            self.window?.makeKeyAndVisible()
        }
        self.window?.makeKeyAndVisible()
    }
    func changeRootViewController (_ vc: UIViewController, animated: Bool) {
        guard let window = self.window else { return }
        window.rootViewController = vc // 전환
    }
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

