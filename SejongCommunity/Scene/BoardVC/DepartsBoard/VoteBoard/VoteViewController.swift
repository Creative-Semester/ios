//
//  VoteViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/08/30.
//

import Foundation
import UIKit
import SnapKit
//게시글의 구조체 정의(게시물을 정보를 담기 위함)
struct VotePost {
    let title : String
    let content : String
    let image : UIImage?
}
//UITableViewDataSource, UITableViewDelegate 테이블뷰와 데이터를 연결
class VoteViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource  {
    //게시글을 저장시킬 테이블 뷰 생성
    let tableView = UITableView()
    let voteposts : [VotePost] = [
        VotePost(title: "박정곤 학생의 교내 추방 투표", content: "박정곤 학생의 교내 추방 투표입니다.", image: nil),
        VotePost(title: "박정곤 학생 집들이 찬반 투표", content: "박정곤 학생 집들이 찬반 투표입니다.", image: nil),
        VotePost(title: "박정곤 학생 피파 잘한다 찬반 투표", content: "박정곤 학생 피파 잘한다 찬반 투표입니다.", image: nil)
    ]
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        let closeIcon = UIImage(systemName: "chevron.backward")
        let MainBackButton = UIBarButtonItem(image: closeIcon, style: .plain, target: self, action: #selector(MainBackButtonTapped))
        self.navigationController?.navigationBar.tintColor = .red
        navigationItem.leftBarButtonItem = MainBackButton
        title = "투표"
        self.view.backgroundColor = .white
        setupTableView()
        //글쓰기 버튼을 상단 바에 추가
        let addButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(WriteBtnTappend))
        navigationItem.rightBarButtonItem = addButton
        setTabBarView()
    }
    //메인으로 돌아갈 백 버튼
    @objc func MainBackButtonTapped() {
        navigationController?.pushViewController(MainViewController(), animated: true)
        //메인으로 이동했을때 탭바를 다시 켬
        tabBarController?.tabBar.isHidden = false
    }
    //학생회 공지사항, 투표를 할 뷰를 나눌 탭바 메서드
    func setTabBarView() {
        //학생회 공지사항 게시글과, 투표글에 대해 뷰를 나눌 탭바설정
        let TabView = UIView()
        TabView.backgroundColor = .white
        TabView.tintColor = .gray
//        TabView.layer.borderWidth = 0.2
        let TabStackView = UIStackView()
        TabStackView.axis = .horizontal
        TabStackView.alignment = .fill
        TabStackView.distribution = .fill
        TabStackView.spacing = 20
        
        //학생회 공지사항 뷰 버튼
        let CouncilView = UIView()
        let CouncilBtn = UIButton()
        CouncilBtn.layer.cornerRadius = 20
        CouncilBtn.layer.masksToBounds = true
        CouncilBtn.setImage(UIImage(systemName: "quote.bubble.fill"), for: .normal)
        CouncilBtn.tintColor = .black
        CouncilBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        CouncilBtn.addTarget(self, action: #selector(CouncilBtnTapped), for: .touchUpInside)
        let CouncilLabel = UILabel()
        CouncilLabel.text = "공지사항"
        CouncilLabel.textAlignment = .center
        CouncilLabel.textColor = .black
        CouncilLabel.font = UIFont.boldSystemFont(ofSize: 10)
        CouncilView.addSubview(CouncilBtn)
        CouncilView.addSubview(CouncilLabel)
        
        //투표 뷰 버튼
        let VoteView = UIView()
        let VoteBtn = UIButton()
        VoteBtn.layer.cornerRadius = 20
        VoteBtn.layer.masksToBounds = true
        VoteBtn.setImage(UIImage(systemName: "slider.horizontal.3"), for: .normal)
        VoteBtn.tintColor = .black
        VoteBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        VoteBtn.addTarget(self, action: #selector(VoteBtnTapped), for: .touchUpInside)
        let VoteLabel = UILabel()
        VoteLabel.text = "투표"
        VoteLabel.textAlignment = .center
        VoteLabel.font = UIFont.boldSystemFont(ofSize: 10)
        VoteView.addSubview(VoteBtn)
        VoteView.addSubview(VoteLabel)
        TabStackView.addArrangedSubview(CouncilView)
        TabStackView.addArrangedSubview(VoteView)
        TabView.addSubview(TabStackView)
        self.view.addSubview(TabView)
        
        TabView.snp.makeConstraints{ (make) in
            make.height.equalTo(self.view.frame.height / 8)
            make.leading.trailing.equalToSuperview().inset(0)
            make.bottom.equalToSuperview().offset(0)
        }
        TabStackView.snp.makeConstraints{ (make) in
            make.top.bottom.trailing.leading.equalToSuperview().inset(0)
        }
        CouncilView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(10)
            make.width.equalToSuperview().dividedBy(2)
        }
        CouncilBtn.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        CouncilLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(CouncilBtn.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        VoteView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(10)
            make.width.equalToSuperview().dividedBy(2)
        }
        VoteBtn.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(18)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        VoteLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(VoteBtn.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(40)
        }
    }
    //공지사항 버튼을 눌렀을때 액션
    @objc func CouncilBtnTapped() {
        navigationController?.pushViewController(DepartBoardViewController(), animated: false)
    }
    //투표 버튼을 눌렀을때 액션
    @objc func VoteBtnTapped() {
        navigationController?.pushViewController(VoteViewController(), animated: false)
    }
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            //부모로 이동했을때 탭바를 다시 켬
            if isMovingFromParent {
                print("Back 버튼 클릭됨")
                tabBarController?.tabBar.isHidden = false
            }
        }
    //테이블뷰를 설정하는 메서드
    func setupTableView() {
        //UITableViewDelegate, UITableDataSource 프로토콜을 해당 뷰컨트롤러에서 구현
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        //UITableView에 셀 등록
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
    }
    // MARK: - UITableViewDataSource
    //테이블 뷰의 데이터 소스 프로토콜을 구현
    //numberOfRowsInSection 메서드 개시물 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voteposts.count
    }
    //cellForRowAt 메서드 각 셀에 해당하는 개시물의 제목 표시
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let post = voteposts[indexPath.row]
        cell.titleLabel.text = post.title
        cell.commentLabel.text = post.content
        cell.postImageView.image = post.image
        
        return cell
    }
    // MARK: - UITableViewDelegate
    //테이블 뷰의 델리게이트 프로토콜을 구현
    //didselectRowAt 메서드 특정 게시물의 상세 내용을 보여주기 위함
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = voteposts[indexPath.row]
        showPostDetail(post: post)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    //셀을 선택했을 때 해당 게시물의 상세 내용을 보여주기 위함
    func showPostDetail(post: VotePost){
        let detailViewController = VotePostDetailViewController(post: post)
        //게시글의 상세 글 볼때 탭바 숨기기
        tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    //글쓰기 버튼을 누르면 글작성 뷰로 이동시킬 메서드
    @objc func WriteBtnTappend() {
        navigationController?.pushViewController(VoteBoardWriteViewController(), animated: true)
    }
}
