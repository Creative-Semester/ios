//
//  DepartBoardViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/07/25.
//

import Foundation
import UIKit
//게시글의 구조체 정의(게시물을 정보를 담기 위함)
struct DepartPost {
    let title : String
    let content : String
    let image : UIImage?
    let day : String
}
//UITableViewDataSource, UITableViewDelegate 테이블뷰와 데이터를 연결
class DepartBoardViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let CouncilButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("공지사항", for: .normal)
        button.addTarget(self, action: #selector(CouncilBtnTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(UIColor(red: 1, green: 0.271, blue: 0.417, alpha: 1), for: .normal)
        return button
    }()
    
    private let VoteButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("투표", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(VoteBtnTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        
        return button
    }()
    //페이지 번호와 크기
    var currentPage = 0
    let activityIndicator = UIActivityIndicatorView(style: .large) // 로딩 인디케이터 뷰
    //게시글을 저장시킬 테이블 뷰 생성
    let tableView = UITableView()
    var departposts : [DepartPost] = [
        DepartPost(title: "첫 번째 게시물", content: "첫 번째 게시물 내용입니다.", image: UIImage(named: "studentCouncil")!, day: "2023-09-19 19:44"),
        DepartPost(title: "두 번째 게시물", content: "두 번째 게시물 내용입니다.", image: nil, day: "2023-09-18 15:42"),
        DepartPost(title: "세 번째 게시물", content: "세 번째 게시물 내용입니다.", image: UIImage(named: "SideLogo")!, day: "2023-09-13 11:02")
    ]
    override func viewDidLoad() {
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationItem.setHidesBackButton(true, animated: false)
        let closeIcon = UIImage(systemName: "chevron.backward")
        let MainBackBtnLabel = UIButton()
        MainBackBtnLabel.setTitle(" 메인페이지", for: .normal)
        MainBackBtnLabel.setTitleColor(.red, for: .normal)
        MainBackBtnLabel.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        MainBackBtnLabel.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        MainBackBtnLabel.addTarget(self, action: #selector(MainBackButtonTapped), for: .touchUpInside)
        MainBackBtnLabel.tintColor = .red
        let MainLabel = UIBarButtonItem(customView: MainBackBtnLabel)
        self.navigationItem.leftBarButtonItems = [MainLabel]
        
        self.navigationController?.navigationBar.tintColor = .red
        title = "학생회 공지사항"
        setupTableView()
        //글쓰기 버튼을 상단 바에 추가
        let addButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(WriteBtnTappend))
        // 우측 바 버튼 아이템 배열에 추가
        navigationItem.rightBarButtonItems = [addButton]
        // 로딩 인디케이터 뷰 초기 설정
        activityIndicator.color = .gray
        activityIndicator.center = view.center
        
        // 처음에 초기 데이터를 불러옴
        fetchPosts(page: currentPage) { [weak self] (newPosts, error) in
                guard let self = self else { return }
                
                if let newPosts = newPosts {
                    // 초기 데이터를 posts 배열에 추가
                    self.departposts += newPosts
                    
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
        //학생회 공지사항, 투표를 할 뷰를 나눌 탭바를 새로 생성
        setTabBarView()
    }
    //메인으로 돌아갈 백 버튼
    @objc func MainBackButtonTapped() {
        if let mainViewController = navigationController?.viewControllers.first(where: { $0 is MainViewController }) {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navigationController?.popToViewController(mainViewController, animated: true)
        }
        //메인으로 이동했을때 탭바를 다시 켬
        tabBarController?.tabBar.isHidden = false
    }
    //테이블뷰를 설정하는 메서드
    func setupTableView() {
        //UITableViewDelegate, UITableDataSource 프로토콜을 해당 뷰컨트롤러에서 구현
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        // 탭 바의 높이만큼 상단 여백 추가
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        //UITableView에 셀 등록
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
    }
    // MARK: - UITableViewDataSource
    //테이블 뷰의 데이터 소스 프로토콜을 구현
    //numberOfRowsInSection 메서드 개시물 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departposts.count
    }
    //cellForRowAt 메서드 각 셀에 해당하는 개시물의 제목 표시
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let post = departposts[indexPath.row]
        cell.titleLabel.text = post.title
        cell.commentLabel.text = post.content
        cell.postImageView.image = post.image
        cell.DayLabel.text = post.day
        return cell
    }
    //학생회 공지사항, 투표를 할 뷰를 나눌 탭바 메서드
    func setTabBarView() {
        //학생회 공지사항 게시글과, 투표글에 대해 뷰를 나눌 탭바설정
        let stackView = UIStackView(arrangedSubviews: [CouncilButton, VoteButton])
        
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
    }
    //공지사항 버튼을 눌렀을때 액션
    @objc func CouncilBtnTapped() {
        navigationController?.pushViewController(DepartBoardViewController(), animated: false)
    }
    //투표 버튼을 눌렀을때 액션
    @objc func VoteBtnTapped() {
        navigationController?.pushViewController(VoteViewController(), animated: false)
    }
    
    // MARK: - UITableViewDelegate
    //테이블 뷰의 델리게이트 프로토콜을 구현
    //didselectRowAt 메서드 특정 게시물의 상세 내용을 보여주기 위함
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = departposts[indexPath.row]
        showPostDetail(post: post)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    //셀을 선택했을 때 해당 게시물의 상세 내용을 보여주기 위함
    func showPostDetail(post: DepartPost){
        let detailViewController = DepartPostDetailViewController(post: post)
        //게시글의 상세 글 볼때 탭바 숨기기
        tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    //글쓰기 버튼을 누르면 글작성 뷰로 이동시킬 메서드
    @objc func WriteBtnTappend() {
        navigationController?.pushViewController(DepartOpenWriteViewController(), animated: true)
    }
    //MARK: - 서버에서 데이터 가져오기
    var isLoading = false  // 중복 로드 방지를 위한 플래그
    func fetchPosts(page: Int, completion: @escaping ([DepartPost]?, Error?) -> Void){
        // 서버에서 페이지와 페이지 크기를 기반으로 게시글 데이터를 가져옴
        // 결과는 completion 핸들러를 통해 반환
        // URLSession을 사용하여 데이터를 가져오는 경우
        let url = URL(string: "https://example.com/api/posts?page=\(page)")!
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
    var updatePageCalled = false // updatePageCalled가 호출되었는지 여부를 추적
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        let screenHeight = scrollView.bounds.size.height
        let threshold: CGFloat = -150 // 이 임계값을 조절하여 스크롤 감지 정확도를 조절할 수 있습니다

        if contentOffsetY >= 0 {
            isScrollingDown = true
        } else {
            isScrollingDown = false
        }

        if isScrollingDown && contentOffsetY + screenHeight >= scrollView.contentSize.height {
            if !loadNextPageCalled { // 호출되지 않은 경우에만 실행
                loadNextPageCalled = true // 호출되었다고 표시
                self.view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                loadNextPage()
            }
        } else if !isScrollingDown && contentOffsetY < threshold {
            if !updatePageCalled {
                updatePageCalled = true
                self.view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                updatePage()
            }
        }
    }

    //새로운 페이지 새로고침
    @objc func updatePage() {
        print("updatePage() - called")
        currentPage = 0 //처음 페이지부터 다시 시작
        isLoading = false
        //스크롤을 감지해서 인디케이터가 시작되면
        //로딩인디케이터를 중지 >> 변경해줘야함. 통신이 끝나면 정지
        // 특정 시간(예: 2초) 후에 로딩 인디케이터 정지
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.activityIndicator.stopAnimating()
                }
        
        // 서버에서 다음 페이지의 데이터를 가져옴
        fetchPosts(page: currentPage) { [weak self] (newPosts, error) in
            guard let self = self else { return }
            // 로딩 인디케이터 멈춤
//            DispatchQueue.main.async {
//                self.activityIndicator.stopAnimating()
//            }
            
            if let newPosts = newPosts {
                // 새로운 데이터를 기존 데이터와 병합
                self.departposts += newPosts
                
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
        //로딩인디케이터를 중지 >> 변경해줘야함. 통신이 끝나면 정지
        // 특정 시간(예: 2초) 후에 로딩 인디케이터 정지
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.activityIndicator.stopAnimating()
                }

        fetchPosts(page: currentPage) { [weak self] (newPosts, error) in
            guard let self = self else { return }
            // 로딩 인디케이터 멈춤
//            DispatchQueue.main.async {
//                self.activityIndicator.stopAnimating()
//            }
            if let newPosts = newPosts {
                self.departposts += newPosts

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
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            //부모로 이동했을때 탭바를 다시 켬
            if isMovingFromParent {
                print("Back 버튼 클릭됨")
                navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                tabBarController?.tabBar.isHidden = false
            }
        }
}
