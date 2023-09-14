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
    //페이지 번호와 크기
    var currentPage = 1
    let pageSize = 20
    let activityIndicator = UIActivityIndicatorView(style: .large) // 로딩 인디케이터 뷰
    //게시글을 저장시킬 테이블 뷰 생성
    let tableView = UITableView()
    var voteposts : [VotePost] = [
        VotePost(title: "박정곤 학생의 교내 추방 투표", content: "박정곤 학생의 교내 추방 투표입니다.", image: nil),
        VotePost(title: "박정곤 학생 집들이 찬반 투표", content: "박정곤 학생 집들이 찬반 투표입니다.", image: nil),
        VotePost(title: "박정곤 학생 피파 잘한다 찬반 투표", content: "박정곤 학생 피파 잘한다 찬반 투표입니다.", image: nil)
    ]
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let closeIcon = UIImage(systemName: "chevron.backward")
        let MainBackButton = UIBarButtonItem(image: closeIcon, style: .plain, target: self, action: #selector(MainBackButtonTapped))
        self.navigationController?.navigationBar.tintColor = .red
        navigationItem.leftBarButtonItem = MainBackButton
        title = "투표"
        self.view.backgroundColor = .white
        setupTableView()
        //글쓰기 버튼을 상단 바에 추가
        let addButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(WriteBtnTappend))
        //새로 고침 버튼 상단 바에 추가
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(updatePage))
        // 우측 바 버튼 아이템 배열에 추가
        navigationItem.rightBarButtonItems = [refreshButton, addButton]
        // 로딩 인디케이터 뷰 초기 설정
        activityIndicator.color = .gray
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        // 처음에 초기 데이터를 불러옴
        fetchPosts(page: currentPage, pageSize: pageSize) { [weak self] (newPosts, error) in
                guard let self = self else { return }
                
                if let newPosts = newPosts {
                    // 초기 데이터를 posts 배열에 추가
                    self.voteposts += newPosts
                    
                    // 테이블 뷰 갱신
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print("Initial data fetch - Success")
                } else if let error = error {
                    // 오류 처리
                    print("Error fetching initial data: \(error.localizedDescription)")
                }
            }
        setTabBarView()
    }
    //메인으로 돌아갈 백 버튼
    @objc func MainBackButtonTapped() {
        if let mainViewController = navigationController?.viewControllers.first(where: { $0 is MainViewController }) {
            navigationController?.popToViewController(mainViewController, animated: true)
        }

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
                navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
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
    //MARK: - 서버에서 데이터 가져오기
    var isLoading = false  // 중복 로드 방지를 위한 플래그
    func fetchPosts(page: Int, pageSize: Int, completion: @escaping ([VotePost]?, Error?) -> Void){
        // 서버에서 페이지와 페이지 크기를 기반으로 게시글 데이터를 가져옴
        // 결과는 completion 핸들러를 통해 반환
        // URLSession을 사용하여 데이터를 가져오는 경우
        let url = URL(string: "https://example.com/api/posts?page=\(page)&pageSize=\(pageSize)")!
        URLSession.shared.dataTask(with: url) { (data, response, error) in
                // 요청이 완료된 후 실행될 클로저
                // 에러 처리
                if let error = error {
                    completion(nil, error)
                    return
                }
                // 데이터 파싱
                guard let data = data else {
                    completion(nil, nil) // 데이터가 없는 경우
                    return
                }
                do {
                    // JSON 데이터를 파싱하여 Post 객체 배열로 변환
//                    let posts = try JSONDecoder().decode([Post].self, from: data)

                    // 성공적으로 데이터를 가져온 경우
//                    completion(posts, nil)
                } catch {
                    // JSON 파싱 오류 처리
                    completion(nil, error)
                }
            }.resume() // URLSession 작업 시작
    }
    var isScrolling = false
    var lastContentOffsetY : CGFloat = 0
    var isScrollingDown = false
    var loadNextPageCalled = false // loadNextPage가 호출되었는지 여부를 추적
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let screenHeight = scrollView.bounds.size.height

        if contentOffsetY >= 0 {
            isScrollingDown = true
        } else {
            isScrollingDown = false
        }

        if isScrollingDown && contentOffsetY + screenHeight >= scrollView.contentSize.height {
            if !loadNextPageCalled { // 호출되지 않은 경우에만 실행
                loadNextPageCalled = true // 호출되었다고 표시
                loadNextPage()
            }
        } else if !isScrollingDown && contentOffsetY == 0 {            loadNextPageCalled = false // 상단으로 스크롤될 때 호출되지 않았다고 표시
        }
    }

    //새로운 페이지 새로고침
    @objc func updatePage() {
        print("updatePage() - called")
        currentPage = 1 //처음 페이지부터 다시 시작
        isLoading = false
        //스크롤을 감지해서 인디케이터가 시작되면
//        activityIndicator.startAnimating() // 로딩 인디케이터 시작
        // 서버에서 다음 페이지의 데이터를 가져옴
        fetchPosts(page: currentPage, pageSize: pageSize) { [weak self] (newPosts, error) in
            guard let self = self else { return }
            // 로딩 인디케이터 멈춤
//            DispatchQueue.main.async {
//                self.activityIndicator.stopAnimating()
//            }
            
            if let newPosts = newPosts {
                // 새로운 데이터를 기존 데이터와 병합
                self.voteposts += newPosts
                
                // 테이블 뷰 갱신
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print("updatePage - Success")
            } else if let error = error {
                // 오류 처리
                print("Error fetching next page: \(error.localizedDescription)")
            }
            self.isLoading = false
        }
    }
    //스크롤이 아래로 내려갈때 기존페이지 + 다음 페이지 로드
    func loadNextPage() {
        print("loadNextPage() - called")
        currentPage += 1
        isLoading = true
        //스크롤을 감지해서 인디케이터가 시작되면
//        activityIndicator.startAnimating() // 로딩 인디케이터 시작

        fetchPosts(page: currentPage, pageSize: pageSize) { [weak self] (newPosts, error) in
            guard let self = self else { return }
            // 로딩 인디케이터 멈춤
//            DispatchQueue.main.async {
//                self.activityIndicator.stopAnimating()
//            }
            if let newPosts = newPosts {
                self.voteposts += newPosts

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print("loadNextPage - Success")
            } else if let error = error {
                print("Error fetching next page: \(error.localizedDescription)")
            }
            self.isLoading = false
            self.loadNextPageCalled = false // 데이터가 로드되었으므로 호출 플래그 초기화
        }
    }
}
