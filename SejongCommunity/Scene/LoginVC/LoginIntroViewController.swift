//
//  LoginIntroViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/08/20.
//

import Foundation
import UIKit

class LoginIntroViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        setUpView()
    }
    func setUpView() {
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.distribution = .fill
        StackView.alignment = .fill
        StackView.backgroundColor = .white
        
        let WelcomeLabel = UILabel()
        WelcomeLabel.text = "Welcome To"
        WelcomeLabel.textColor = .red
        WelcomeLabel.textAlignment = .center
        WelcomeLabel.backgroundColor = .white
        WelcomeLabel.font = UIFont.boldSystemFont(ofSize: 15)
        StackView.addArrangedSubview(WelcomeLabel)
        
        let LogoImage = UIImage(named: "")
    }
}
