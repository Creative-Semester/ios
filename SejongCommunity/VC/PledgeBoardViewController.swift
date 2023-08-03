//
//  PledgeBoardViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/07/26.
//

import UIKit

class PledgeBoardViewController: UIViewController {
    
    private let welfareButton: UIButton = {
        let button = UIButton()
        button.setTitle("복지행사", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(pledgeMenuButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIColor(red: 1, green: 0.271, blue: 0.417, alpha: 1), for: .selected)

        return button
    }()
    
    private let cultureButton: UIButton = {
        let button = UIButton()
        button.setTitle("문화행사", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(pledgeMenuButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIColor(red: 1, green: 0.271, blue: 0.417, alpha: 1), for: .selected)
        
        return button
    }()
    //scholarship
    private let scholarshipButton: UIButton = {
        let button = UIButton()
        button.setTitle("학술행사", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(pledgeMenuButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(UIColor(red: 1, green: 0.271, blue: 0.417, alpha: 1), for: .selected)
        
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "공약전체보기"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
    }
    
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [welfareButton, cultureButton, scholarshipButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.backgroundColor = UIColor(red: 1, green: 0.867, blue: 0.867, alpha: 1)
        
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
        }
        
        welfareButton.isSelected = true
    }
    
    @objc func pledgeMenuButtonTapped(_ sender: UIButton) {
        // 모든 버튼의 선택 상태를 초기화
        welfareButton.isSelected = false
        cultureButton.isSelected = false
        scholarshipButton.isSelected = false
        
        // 현재 클릭한 버튼의 선택 상태를 true로 설정
        sender.isSelected = true
        
        if sender == welfareButton {
            
        } else if sender == cultureButton {
            
        } else if sender == scholarshipButton {
            
        }
    }

}
