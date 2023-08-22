//
//  MainTabBarController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/07/23.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white
        tabBar.tintColor = .gray
        tabBar.unselectedItemTintColor = .black
        tabBar.barTintColor = .white

        let vc1 = MainViewController()
        let vc2 = ChatViewController()
        let vc3 = MypageViewController()

        vc1.tabBarItem = UITabBarItem(title: "메인페이지", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        vc2.tabBarItem = UITabBarItem(title: "메시지", image: UIImage(systemName: "bubble.right"), selectedImage: UIImage(systemName: "bubble.right.fill"))
        vc3.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)

        setViewControllers([nav1, nav2, nav3], animated: false)
    }

}
