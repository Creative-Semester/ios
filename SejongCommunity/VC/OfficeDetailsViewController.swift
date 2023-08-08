//
//  VoteBoardViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/07/26.
//

import UIKit

class OfficeDetailsViewController: UIViewController {

    private var isEditingMode: Bool = false
    
    private let officeDetailsTitleLabel: UILabel = {
       let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "사무내역"
        label.numberOfLines = 1

        return label
    }()
    
    private let officeDetailsTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        self.title = "사무내역 전체보기"
        
        setupNavigationBar()
        setupUI()
        officeDetailsTableView.dataSource = self
        officeDetailsTableView.delegate = self
        officeDetailsTableView.register(OfficeDetailsTableViewCell.self, forCellReuseIdentifier: "OfficeDetailsTableViewCell")
    }
    
}

extension OfficeDetailsViewController: UITableViewDelegate, UITableViewDataSource{
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "OfficeDetailsTableViewCell", for: indexPath) as! OfficeDetailsTableViewCell
        
        return cell
    }
    
    //Cell의 높이를 지정한다.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    //cell이 클릭되었을때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = OfficeDetailsCellTappedViewController()
        
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 삭제할 데이터를 배열에서 제거하고 테이블 뷰 갱신
            
            // 이후 필요한 서버 통신 또는 데이터 처리를 수행할 수 있음
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if isEditingMode {
            return .delete
        } else {
            return .none
        }
    }
}

private extension OfficeDetailsViewController {
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

        view.addSubview(officeDetailsTitleLabel)
        view.addSubview(officeDetailsTableView)
        
        officeDetailsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
        }
        
        officeDetailsTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    @objc func editButtonTapped() {
        isEditingMode.toggle()
        
        // 네비게이션 바 우측 버튼 텍스트 변경
        setupNavigationBar()
        officeDetailsTableView.reloadData()
    }
    
}
