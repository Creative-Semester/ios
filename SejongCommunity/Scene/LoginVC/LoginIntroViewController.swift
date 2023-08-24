//
//  LoginIntroViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/08/20.
//

import Foundation
import UIKit
import SnapKit

class LoginIntroViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBarController?.tabBar.isHidden = true
        self.view.backgroundColor = .white
        setUpAutoLayout()
    }
    //화면을 구성하는 요소들 추가
    private let FirstLabel : UILabel = {
        let WelcomeLabel = UILabel()
        WelcomeLabel.text = "Welcome To"
        WelcomeLabel.textColor =  #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        WelcomeLabel.font = UIFont.boldSystemFont(ofSize: 15)
        WelcomeLabel.textAlignment = .center
        WelcomeLabel.backgroundColor = .white
        
        return WelcomeLabel
    }()
    
    //세종대학교 로고 이미지
    private let LogoImage : UIImageView = {
        let image = UIImage(named: "")
        let ImageView = UIImageView(image: image)
        ImageView.backgroundColor = .black
        ImageView.contentMode = .scaleAspectFit
        
        return ImageView
    }()
    
    //로그인 버튼
    private let Btn : UIButton = {
        let LoginBtn = UIButton()
        LoginBtn.setTitle("Sign in with SejongEmail", for: .normal)
        LoginBtn.setTitleColor(.black, for: .normal)
        LoginBtn.backgroundColor = #colorLiteral(red: 1, green: 0.8216146827, blue: 0.8565195203, alpha: 1)
        LoginBtn.layer.cornerRadius = 30
        LoginBtn.layer.masksToBounds = true
        
        return LoginBtn
    }()
    
    //설명 라벨
    private let SecondLabel : UILabel = {
        let ExplainLabel = UILabel()
        ExplainLabel.text = "세종대학교 포털 아이디로 자동 로그인됩니다."
        ExplainLabel.textColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        ExplainLabel.font = UIFont.boldSystemFont(ofSize: 15)
        ExplainLabel.textAlignment = .center
        ExplainLabel.backgroundColor = .white
        
        return ExplainLabel
    }()
    
    //오토레이아웃을 위해 스택뷰 설정
    private let StackView : UIStackView = {
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.alignment = .fill
        StackView.distribution = .fill
        StackView.backgroundColor = .white
        
        return StackView
    }()
}
// 각 요소들의 오토레이아웃 설정을 위한 클래스 확장
extension LoginIntroViewController {
    func setUpAutoLayout(){
        StackView.addArrangedSubview(FirstLabel)
        StackView.addArrangedSubview(LogoImage)
        StackView.addArrangedSubview(Btn)
        StackView.addArrangedSubview(SecondLabel)
        view.addSubview(StackView)
        
        //SnapKit을 이용한 오토레이아웃 설정
        StackView.snp.makeConstraints{ (make) in
            make.bottom.trailing.leading.equalToSuperview().inset(0)
            make.top.equalToSuperview().offset(self.view.frame.height / 8.5)
        }
        FirstLabel.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(0)
            make.trailing.leading.equalToSuperview().inset(40)
//            make.width.equalTo(StackView.snp.width).dividedBy(2)
            make.height.equalTo(StackView.snp.height).dividedBy(12)
        }
        LogoImage.snp.makeConstraints{ (make) in
            make.top.equalTo(FirstLabel.snp.bottom).offset(20)
            make.trailing.leading.equalToSuperview().inset(40)
            make.height.equalTo(StackView.snp.height).dividedBy(2)
        }
        Btn.snp.makeConstraints{ (make) in
//            make.top.equalTo(LogoImage.snp.bottom).offset(30)
            make.trailing.leading.equalToSuperview().inset(20)
            make.height.equalTo(StackView.snp.height).dividedBy(10)
        }
        SecondLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(Btn.snp.bottom).offset(0)
            make.trailing.leading.equalToSuperview().inset(40)
        }
    }
}
