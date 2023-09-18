//
//  ProfessorDetailClassViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/09/13.
//

import UIKit
import SnapKit

class ProfessorDetailClassViewController: UIViewController {

    private let professorReviewTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    private let reviewView = UIView()
    
    private let reviewTextField: UITextField = {
        let textField = UITextField()
        
        textField.backgroundColor = .lightGray
        textField.layer.cornerRadius = 10
        
        return textField
    }()
    
    private let reviewRegisterButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "message"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = UIColor(red: 1, green: 0.788, blue: 0.788, alpha: 1)
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "신호 및 시스템 강의평"
        
        professorReviewTableView.dataSource = self
        professorReviewTableView.delegate = self
        professorReviewTableView.register(ProfessorReviewTableViewCell.self, forCellReuseIdentifier: "ProfessorReviewTableViewCell")
        
        reviewTextField.delegate = self
        
        // 키보드 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        setupLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        
    }

    func setupLayout() {
        
        view.addSubview(reviewView)
        reviewView.snp.makeConstraints{ make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        reviewView.addSubview(reviewRegisterButton)
        reviewRegisterButton.snp.makeConstraints{ make in
            make.trailing.equalTo(reviewView.snp.trailing).inset(12)
            make.centerY.equalTo(reviewView.snp.centerY)
            make.height.width.equalTo(40)
        }
        
        reviewView.addSubview(reviewTextField)
        reviewTextField.snp.makeConstraints{ make in
            make.leading.equalTo(reviewView.snp.leading).inset(12)
            make.trailing.equalTo(reviewRegisterButton.snp.leading).offset(-6)
            make.centerY.equalTo(reviewView.snp.centerY)
            make.height.width.equalTo(40)
        }
        
        view.addSubview(professorReviewTableView)
        professorReviewTableView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(reviewView.snp.top)
        }
        
    }
    
    func heightForText(_ text: String) -> CGFloat {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12) // 원하는 폰트 크기 설정
        label.numberOfLines = 0 // 여러 줄 허용
        label.text = text
        
        // 텍스트를 표시하고 있는 라벨의 크기를 계산
        let size = label.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 24, height: CGFloat.greatestFiniteMagnitude))
        
        return size.height
    }
}

extension ProfessorDetailClassViewController: UITextFieldDelegate {
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        
        
    }
}

extension ProfessorDetailClassViewController: UITableViewDataSource {
    
    // 섹션의 갯수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //각 섹션 마다 cell row 숫자의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 15
    }
    
    // 각 센션 마다 사용할 cell의 종류
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfessorReviewTableViewCell", for: indexPath) as! ProfessorReviewTableViewCell
        
        return cell
    }
    
}

extension ProfessorDetailClassViewController: UITableViewDelegate {
    
    //Cell의 높이를 지정한다.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let commtenText =
        """
        요즘 이것만큼 좋은 강의가 있나?
        이것은 혁명이다.
        조선 혁명당입니다만 김씨일가 화이팅
        """
        
        let textHeight = heightForText(commtenText)
        let additionalSpacing = CGFloat(76)
        
        return textHeight + additionalSpacing
    }
}
