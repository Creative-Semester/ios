//
//  ProfessorInfoViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/09/11.
//

import UIKit
import SnapKit

class ProfessorInfoViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()

        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()

    private let professorImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "professor")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 20
        
        return imageView
    }()
    
    private let professorNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "김세원"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let professorExpLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = """
        교수실 : AI센터 524호
        연락처 : 02-6935-2678
        이메일 : sewonkim@sejong.ac.kr
        전  공 : Autonomous Ship
        연구실 : Autonomous Shipping Lab
        """
        label.numberOfLines = 0
        
        return label
    }()
    
    private let lineView: UIView = {
       let view = UIView()
        
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    private let professorClassTitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "교수님 강의 게시판"
        label.numberOfLines = 0
        
        return label
    }()
    
    private let professorClassTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "교수게시판"
        
        professorClassTableView.dataSource = self
        professorClassTableView.delegate = self
        professorClassTableView.register(ProfessorClassTableViewCell.self, forCellReuseIdentifier: "ProfessorClassTableViewCell")
        
        setupLayout()
    }
    
    // 스크롤 뷰의 높이 계산
    func calculateScrollViewHeight() -> CGFloat {
        let infoViewHeight: CGFloat = 203
        let cellCount: CGFloat  = 15
        let cellHeight: CGFloat  = 60
        print(cellCount * cellHeight + infoViewHeight)
        
        return cellCount * cellHeight + infoViewHeight
    }
    

    func setupLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(calculateScrollViewHeight())
        }
        
        scrollView.addSubview(professorImageView)
        professorImageView.snp.makeConstraints{ make in
            make.top.equalTo(scrollView.snp.top).offset(14)
            make.leading.equalTo(scrollView.snp.leading).offset(14)
            make.height.width.equalTo(130)
        }
        
        scrollView.addSubview(professorNameLabel)
        professorNameLabel.snp.makeConstraints{ make in
            make.top.equalTo(professorImageView.snp.top).offset(4)
            make.leading.equalTo(professorImageView.snp.trailing).offset(14)
            make.height.equalTo(20)
        }
        
        scrollView.addSubview(professorExpLabel)
        professorExpLabel.snp.makeConstraints{ make in
            make.top.equalTo(professorNameLabel.snp.bottom).offset(14)
            make.leading.equalTo(professorImageView.snp.trailing).offset(14)
            make.trailing.equalTo(scrollView.snp.trailing).inset(14)
        }
        
        scrollView.addSubview(lineView)
        lineView.snp.makeConstraints{ make in
            make.top.equalTo(professorImageView.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(14)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        scrollView.addSubview(professorClassTitleLabel)
        professorClassTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(lineView.snp.bottom).offset(14)
            make.leading.equalTo(scrollView.snp.leading).offset(14)
        }
        
        scrollView.addSubview(professorClassTableView)
        professorClassTableView.snp.makeConstraints{ make in
            make.top.equalTo(professorClassTitleLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(14)
            make.centerX.equalToSuperview()
            make.height.equalTo(60 * 15)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
    }
    
}


extension ProfessorInfoViewController: UITableViewDataSource{
    
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfessorClassTableViewCell", for: indexPath) as! ProfessorClassTableViewCell
        
        return cell
    }
    
}

extension ProfessorInfoViewController: UITableViewDelegate {
    //cell이 클릭되었을때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = ProfessorDetailClassViewController()
        
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //Cell의 높이를 지정한다.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
