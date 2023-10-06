//
//  DepartBoardViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/07/25.
//

import Foundation
import UIKit
import SwiftKeychainWrapper
//게시글의 구조체 정의(게시물을 정보를 담기 위함)
struct DepartPost: Decodable {
    let boardId: Int
    let title: String
    let content: String
    let images: Images
    let day: String
    let page: Int
    struct Images: Decodable {
        let imageName: String
        let imageUrl: String
    }
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
    
    //게시글을 저장시킬 테이블 뷰 생성
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView(style: .large) // 로딩 인디케이터 뷰
    var departposts : [DepartPost] = [
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
        tableView.isScrollEnabled = true
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
        cell.DayLabel.text = post.day
        
        //MARK: - URL to Image Conversion
        // 첫 번째 이미지가 nil이면 안함.
        if !post.images.imageUrl.isEmpty {
            // 이미지 URL 가져오기
            if let imageUrl = URL(string: post.images.imageUrl) {
                // KingFisher를 사용하여 이미지 로드 및 표시
                print("이미지를 가져옵니다. - \(post.images.imageUrl)")
                print("이미지를 post 합니다. \(imageUrl)")
                cell.postImageView.kf.setImage(with: imageUrl)
            }
        }
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
    func fetchPosts(page: Int, completion: @escaping ([DepartPost]?, Error?) -> Void) {
        let url = URL(string: "http://15.164.161.53:8082/api/v1/boards?page=\(page)&boardType=Council")!
        if AuthenticationManager.isTokenValid(){}else{} //토큰 유효성 검사
        let acToken = KeychainWrapper.standard.string(forKey: "AuthToken")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(acToken, forHTTPHeaderField: "accessToken")
        var page = currentPage
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, nil)
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let result = json?["result"] as? [String: Any], let boards = result["boards"] as? [[String: Any]] {
                    var posts = [DepartPost]()
                    for board in boards {
                        if let title = board["title"] as? String,
                           let content = board["content"] as? String,
                           let boardId = board["boardId"] as? Int,
                           // 이미지 가져오기 수정해야함.
//                           let images = board["images"] as? [String: Any],
//                           let imageUrls = images["imageUrl"] as? String,
//                           let imageNames = images["imageName"] as? String,
                           let day = board["createdTime"] as? String
                        {
                            let post = DepartPost(boardId: boardId, title: title, content: content, images: DepartPost.Images(imageName: "", imageUrl: ""), day: day, page: page)
                            posts.append(post)
                        }
                    }
                    completion(posts, nil)
                } else {
                    completion(nil, nil)
                }
            } catch {
                completion(nil, error)
            }
        }.resume()
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
        //스크롤을 감지해서 인디케이터가 시작되면 종료가 되면 로딩인디케이터를 멈처야함
        // 서버에서 다음 페이지의 데이터를 가져옴
        fetchPosts(page: currentPage) { [weak self] (newPosts, error) in
            guard let self = self else { return }
            // 데이터를 비워줌
            self.departposts.removeAll()
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
            // 로딩 인디케이터 멈춤
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            self.updatePageCalled = false // 데이터가 로드되었으므로 호출 플래그 초기화
        }
    }
    //스크롤이 아래로 내려갈때 기존페이지 + 다음 페이지 로드
    func loadNextPage() {
        print("loadNextPage() - called")
        currentPage += 1
        isLoading = true
        //스크롤을 감지해서 인디케이터가 시작되면 통신이 완료되면 종료해야함.

        fetchPosts(page: currentPage) { [weak self] (newPosts, error) in
            guard let self = self else { return }
            if let newPosts = newPosts {
                self.departposts += newPosts
                // 테이블뷰 갱신
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print("loadNextPage - Success")
            } else if let error = error {
                print("Error fetching next page: \(error.localizedDescription)")
            }
            // 로딩 인디케이터 멈춤
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
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
