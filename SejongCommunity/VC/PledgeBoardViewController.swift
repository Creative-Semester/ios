//
//  PledgeBoardViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/07/26.
//

import UIKit
import SnapKit

class PledgeBoardViewController: UIViewController {
    
    private var pledgeTitle: String = "복지행사 공약"
    
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
    
//    private let pledgeTitleLabel: UILabel = {
//       let label = UILabel()
//
//        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)//임시로 추가
//        label.textColor = .black
//        label.textAlignment = .left
//        label.text = "복지행사 공약"
//        label.numberOfLines = 1
//
//        return label
//    }()
    
    private let pledgeTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "공약전체보기"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        pledgeTableView.dataSource = self
        pledgeTableView.delegate = self
        pledgeTableView.register(PledgeTableViewCell.self, forCellReuseIdentifier: "PledgeTableViewCell")
        
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
        
        view.addSubview(pledgeTableView)
        
        pledgeTableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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
            pledgeTitle = "복지행사 공약"
        } else if sender == cultureButton {
            pledgeTitle = "문화행사 공약"
        } else if sender == scholarshipButton {
            pledgeTitle = "학술행사 공약"
        }
    }

}

extension PledgeBoardViewController: UITableViewDelegate, UITableViewDataSource{
    
    // 섹션의 갯수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //각 섹션 마다 cell row 숫자의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    // 각 센션 마다 사용할 cell의 종류
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PledgeTableViewCell", for: indexPath) as! PledgeTableViewCell
        
        return cell
    }
    
    //Cell의 높이를 지정한다.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

