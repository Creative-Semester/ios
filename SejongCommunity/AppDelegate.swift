//
//  AppDelegate.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/07/19.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //MARK: - 토큰 유효성 검사 > 로그인 검사
//        if AuthenticationManager.isUserLoggedIn() {
//                    // 사용자가 로그인되어 있는 경우 탭바 컨트롤러를 보여줍니다.
//        let mainTabBarController = MainTabBarController()
//        self.window?.rootViewController = mainTabBarController
//        } else {
//        // 사용자가 로그인되어 있지 않은 경우 로그인 뷰 컨트롤러를 보여줍니다.
//        let loginViewController = LoginViewController()
//        let navigationController = UINavigationController(rootViewController: loginViewController)
//        self.window?.rootViewController = navigationController
//                }
//                
//        self.window?.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

