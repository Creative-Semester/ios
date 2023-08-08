//
//  PledgeBoardViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/07/26.
//

import UIKit
import SnapKit

class PledgeBoardViewController: UIViewController {
    
    private var isEditingMode: Bool = false
    
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
    
    private let pledgeTitleLabel: UILabel = {
       let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "복지행사 공약"
        label.numberOfLines = 1

        return label
    }()
    
    private let pledgeTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        
        self.title = "공약전체보기"
        
        pledgeTableView.dataSource = self
        pledgeTableView.delegate = self
        pledgeTableView.register(PledgeTableViewCell.self, forCellReuseIdentifier: "PledgeTableViewCell")
        
        setupUI()
    }

}

extension PledgeBoardViewController: UITableViewDelegate, UITableViewDataSource{
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PledgeTableViewCell", for: indexPath) as! PledgeTableViewCell
        
        // 드래그 삭제 기능을 허용할 때만 셀의 드래그 삭제 스타일 설정
//        if 학생회 {
//            cell.showsReorderControl = true
//            cell.selectionStyle = .default
//        } else {
//            cell.showsReorderControl = false
//            cell.selectionStyle = .none
//        }
        
        return cell
    }
    
    //Cell의 높이를 지정한다.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 사용자가 셀을 선택했을 때 호출되는 메서드
        // indexPath를 사용하여 선택된 셀의 정보를 가져올 수 있음
        
        let selectedRow = indexPath.row
        print("Selected row: \(selectedRow)")
        
        if let cell = tableView.cellForRow(at: indexPath) as? PledgeTableViewCell {
            // isSelected 값을 토글
            cell.isCompletion.toggle()
            // 선택된 셀의 레이아웃을 업데이트
            cell.setup()
        }
        
        // 선택된 셀에 대한 추가 작업을 수행
        // 예를 들어, 다음 뷰 컨트롤러로 이동하거나 상세 정보를 표시하는 등의 작업
    }
    
    //편집모드일때만 cell클릭할수있도록 변경
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if isEditingMode {
            return indexPath
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 선택한 행을 삭제하고 테이블 뷰에서도 삭제
            // 여기에 실제 삭제 작업을 구현하세요
            tableView.beginUpdates()
            // 삭제 작업 (예: 데이터 소스에서 항목 제거)
            // data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

private extension PledgeBoardViewController {
    func setupNavigationBar() {
        let editButtonTitle = isEditingMode ? "저장" : "편집"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: editButtonTitle,
            style: .plain,
            target: self,
            action: #selector(editButtonTapped)
        )
        
        let textColor = isEditingMode ? UIColor.systemBlue : UIColor.systemRed
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([.foregroundColor: textColor], for: .normal)
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
        
        view.addSubview(pledgeTitleLabel)
        
        pledgeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
        }
        
        view.addSubview(pledgeTableView)
        
        pledgeTableView.snp.makeConstraints { make in
            make.top.equalTo(pledgeTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        welfareButton.isSelected = true
    }
    
    @objc func editButtonTapped() {
        isEditingMode.toggle()
        
        // 네비게이션 바 우측 버튼 텍스트 변경
        setupNavigationBar()
        pledgeTableView.reloadData()
    }
    
    @objc func pledgeMenuButtonTapped(_ sender: UIButton) {
        // 모든 버튼의 선택 상태를 초기화
        welfareButton.isSelected = false
        cultureButton.isSelected = false
        scholarshipButton.isSelected = false
        
        // 현재 클릭한 버튼의 선택 상태를 true로 설정
        sender.isSelected = true
        
        if sender == welfareButton {
            pledgeTitleLabel.text = "복지행사 공약"
        } else if sender == cultureButton {
            pledgeTitleLabel.text = "문화행사 공약"
        } else if sender == scholarshipButton {
            pledgeTitleLabel.text = "학술행사 공약"
        }
        
        pledgeTableView.reloadData()
    }
}
