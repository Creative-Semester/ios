//
//  VoteBoardViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/07/26.
//

import UIKit

class OfficeDetailsViewController: UIViewController {
    
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
        
        setupUI()
        setupNavigation()
        officeDetailsTableView.dataSource = self
        officeDetailsTableView.delegate = self
        officeDetailsTableView.register(OfficeDetailsTableViewCell.self, forCellReuseIdentifier: "OfficeDetailsTableViewCell")
    }
    
    func setupNavigation() {
        // 네비게이션 바에 버튼 추가
        if true { //학생회 일 경우로 수정하기.
            let writingButton = UIBarButtonItem(image: UIImage(systemName: "square.and.pencil"), style: .plain, target: self, action: #selector(writingButtonTapped))
            self.navigationItem.rightBarButtonItem = writingButton
        }
    }
    
    @objc func writingButtonTapped() {
        //사무내역 작성 페이지로 이동
        let vc = WriteOfficeDetailsViewController()
        navigationController?.pushViewController(vc, animated: true)
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
    
}

private extension OfficeDetailsViewController {
    
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
    
}
