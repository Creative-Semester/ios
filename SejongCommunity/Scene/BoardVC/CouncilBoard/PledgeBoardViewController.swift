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
    private let menuItems = ["복지행사", "문화행사", "학술행사", "건강행사", "아무거나"]
    
    private let menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    private let pledgeTitleLabel: UILabel = {
       let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.text = ""
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
        
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self
        menuCollectionView.register(PledgeBoardMenuCollectionViewCell.self, forCellWithReuseIdentifier: "PledgeBoardMenuCollectionViewCell")
        
        pledgeTitleLabel.text = menuItems[0] + " 공약"
        
        pledgeTableView.dataSource = self
        pledgeTableView.delegate = self
        pledgeTableView.register(PledgeTableViewCell.self, forCellReuseIdentifier: "PledgeTableViewCell")
        
        setupLayout()
    }
    
    func setupLayout() {
        view.addSubview(menuCollectionView)
        menuCollectionView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(35)
        }
        
        view.addSubview(pledgeTableView)
        pledgeTableView.snp.makeConstraints{ make in
            make.top.equalTo(menuCollectionView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
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
        
        return 15
    }
    
    // 각 센션 마다 사용할 cell의 종류
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PledgeTableViewCell", for: indexPath) as! PledgeTableViewCell
        
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
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        
        headerView.addSubview(pledgeTitleLabel)
        pledgeTitleLabel.snp.makeConstraints{ make in
            make.leading.equalTo(headerView.snp.leading).offset(16)
            make.centerY.equalTo(headerView.snp.centerY)
        }
        
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //헤더 높이 뷰
        return 40
    }
    
    //편집모드일때만 cell클릭할수있도록 변경
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if isEditingMode {
            return indexPath
        } else {
            return nil
        }
    }
}

extension PledgeBoardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PledgeBoardMenuCollectionViewCell", for: indexPath) as! PledgeBoardMenuCollectionViewCell
        
        cell.configure(with: menuItems[indexPath.item])
        
        return cell
    }
    
    // 처음에 첫번째 cell이 클릭된 상태로 표시하기 위해서 설정했습니다.
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .left)
            cell.contentView.backgroundColor = UIColor(red: 1, green: 0.788, blue: 0.788, alpha: 1)
        }
    }
}

extension PledgeBoardViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 35)
    }
    
    // 셀 선택 시 호출되는 메서드
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pledgeTitleLabel.text = menuItems[indexPath.item] + " 공약"
        // 선택한 셀의 색상을 변경
        if let selectedCell = collectionView.cellForItem(at: indexPath) {
            selectedCell.layer.cornerRadius = 15
            selectedCell.contentView.backgroundColor = UIColor(red: 1, green: 0.788, blue: 0.788, alpha: 1)
        }
    }
    
    // 셀 선택 해제 시 호출되는 메서드
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        // 선택 해제된 셀의 색상을 원래대로 변경
        if let deselectedCell = collectionView.cellForItem(at: indexPath) {
            deselectedCell.contentView.backgroundColor = UIColor(red: 1, green: 0.788, blue: 0.788, alpha: 0.3)
            deselectedCell.layer.cornerRadius = 15
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
    
    
    @objc func editButtonTapped() {
        isEditingMode.toggle()
        
        // 네비게이션 바 우측 버튼 텍스트 변경
        setupNavigationBar()
        pledgeTableView.reloadData()
    }
    
    
}
