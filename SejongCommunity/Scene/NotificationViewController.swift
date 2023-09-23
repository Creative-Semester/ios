//
//  NotificationViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/09/04.
//

import Foundation
import UIKit
import SnapKit

class NotificationViewController : UIViewController {
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            //부모로 이동했을때 탭바를 다시 켬
            if isMovingFromParent {
                print("Back 버튼 클릭됨")
                tabBarController?.tabBar.isHidden = false
                navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            }
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        title = "공지사항"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black] 
        self.navigationController?.navigationBar.tintColor = .red
        setupView()
    }
    func setupView(){
        //각 뷰들을 넣을 스크롤뷰 생성
        let ScrollView = UIScrollView()
        ScrollView.backgroundColor = .white
        ScrollView.isScrollEnabled = true
        ScrollView.showsHorizontalScrollIndicator = true
        //스택뷰를 이용해 오토레이아웃 설정
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.distribution = .fill
        StackView.alignment = .fill
        StackView.spacing = 20
        
        //공지사항 이미지를 넣을 뷰
        let imageView = UIImageView()
        let image = UIImage(named: "Notification")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        StackView.addArrangedSubview(imageView)
        ScrollView.addSubview(StackView)
        self.view.addSubview(ScrollView)
        //SnapKit을 이용한 오토레이아웃 설정
        ScrollView.snp.makeConstraints{ (make) in
            make.bottom.equalToSuperview().offset(-self.view.frame.height / 8.5)
            make.top.equalToSuperview().offset(self.view.frame.height / 8.5)
            make.trailing.leading.equalToSuperview().inset(0)
        }
        StackView.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(ScrollView.snp.height)
            make.width.equalTo(ScrollView.snp.width)
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-3)
        }
        imageView.snp.makeConstraints{ (make) in
            make.top.bottom.leading.trailing.equalToSuperview().inset(0)
        }
    }
}
