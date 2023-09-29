//
//  OpenBoardViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/07/25.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher //url - > image 변환 라이브러리
//게시글의 구조체 정의(게시물을 정보를 담기 위함)
struct Post {
    let title : String
    let content : String
    let imageUrls : [String] // 이미지 URL을 배열로 저장
    let day : String
}
//UITableViewDataSource, UITableViewDelegate 테이블뷰와 데이터를 연결
class OpenBoardViewController : UIViewController, UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate {
    //페이지 번호와 크기
    var currentPage = 0
    
    //게시글을 저장시킬 테이블 뷰 생성
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView(style: .large) // 로딩 인디케이터 뷰
    var posts : [Post] = [
        Post(title: "첫 번째 게시물 제목",
             content: "첫 번째 게시물 내용",
             imageUrls: [
                "https://example.com/image1-1.jpg",
                "https://example.com/image1-2.jpg",
                "https://example.com/image1-3.jpg",
                "https://example.com/image1-4.jpg",
                "https://example.com/image1-5.jpg"
            ],
             day: "2023-09-19 19:44"),
        Post(title: "두 번째 게시물 제목",
             content: "두 번째 게시물 내용",
             imageUrls: [
                "https://example.com/image2-1.jpg",
                "https://example.com/image2-2.jpg",
                "https://example.com/image2-3.jpg",
                "https://example.com/image2-4.jpg",
                "https://example.com/image2-5.jpg"
            ],
             day: "2023-09-19 19:44"),
        Post(title: "세 번째 게시물 제목",
             content: "세 번째 게시물 내용",
             imageUrls: [
                "https://example.com/image3-1.jpg",
                "https://example.com/image3-2.jpg",
                "https://example.com/image3-3.jpg",
                "https://example.com/image3-4.jpg",
                "https://example.com/image3-5.jpg"
            ],
             day: "2023-09-19 19:44")
    ]
    override func viewDidLoad() {
        self.navigationController?.navigationBar.tintColor = .red
        title = "자유게시판"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
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
                    self.posts += newPosts
                    
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
    }
    //테이블뷰를 설정하는 메서드
    func setupTableView() {
        //UITableViewDelegate, UITableDataSource 프로토콜을 해당 뷰컨트롤러에서 구현
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
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
        return posts.count
    }
    //cellForRowAt 메서드 각 셀에 해당하는 개시물의 제목 표시
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let post = posts[indexPath.row]
        cell.titleLabel.text = post.title
        cell.commentLabel.text = post.content
        cell.DayLabel.text = post.day
        
        //MARK: - URL to Image Conversion
        // 첫 번째 이미지 URL 가져오기
        if let firstImageUrl = post.imageUrls.first, let imageUrl = URL(string: firstImageUrl) {
            // KingFisher를 사용하여 이미지 로드 및 표시
            print("첫 번째 이미지를 가져옵니다. - \(firstImageUrl)")
            print("첫 번째 이미지를 post 합니다. \(imageUrl)")
            cell.postImageView.kf.setImage(with: imageUrl)
        }
        return cell
    }
    // MARK: - UITableViewDelegate
    //테이블 뷰의 델리게이트 프로토콜을 구현
    //didselectRowAt 메서드 특정 게시물의 상세 내용을 보여주기 위함
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = posts[indexPath.row]
        showPostDetail(post: post)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    //셀을 선택했을 때 해당 게시물의 상세 내용을 보여주기 위함
    func showPostDetail(post: Post){
        let detailViewController = PostDetailViewController(post: post)
        //게시글의 상세 글 볼때 탭바 숨기기
        tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    //글쓰기 버튼을 누르면 글작성 뷰로 이동시킬 메서드
    @objc func WriteBtnTappend() {
        navigationController?.pushViewController(OpenWriteViewController(), animated: true)
    }
    //MARK: - 서버에서 데이터 가져오기
    var isLoading = false  // 중복 로드 방지를 위한 플래그
    func fetchPosts(page: Int, completion: @escaping ([Post]?, Error?) -> Void){
        // 서버에서 페이지와 페이지 크기를 기반으로 게시글 데이터를 가져옴
        // 결과는 completion 핸들러를 통해 반환
        // URLSession을 사용하여 데이터를 가져오는 경우
        let url = URL(string: "https://example.com/api/posts?page=\(page)")!
        //토큰을 추가해야함.
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
                activityIndicator.startAnimating() // 로딩 인디케이터 시작
                loadNextPage()
            }
        } else if !isScrollingDown && contentOffsetY < threshold {
            if !updatePageCalled {
                updatePageCalled = true
                self.view.addSubview(activityIndicator)
                activityIndicator.startAnimating() // 로딩 인디케이터 시작
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
                self.posts += newPosts
                
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
                self.posts += newPosts

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
    // 뷰 컨트롤러가 부모로 이동될 때 호출
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            if isMovingFromParent {
                // 해당 뷰 컨트롤러가 부모로부터 제거될 때 실행됩니다.
                navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            }
    }
}
