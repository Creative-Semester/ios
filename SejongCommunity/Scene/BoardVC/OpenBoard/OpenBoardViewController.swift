//
//  OpenBoardViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/07/25.
//

import Foundation
import UIKit
import SnapKit
import SwiftKeychainWrapper
import Kingfisher //url - > image 변환 라이브러리
//게시글의 구조체 정의(게시물을 정보를 담기 위함)
struct Post: Decodable {
    let boardId: Int
    let title: String
    let content: String
    let images: [Images]
    let day: String
    let page: Int
    struct Images: Decodable {
        let imageName: String
        let imageUrl: String
    }
}
//UITableViewDataSource, UITableViewDelegate 테이블뷰와 데이터를 연결
class OpenBoardViewController : UIViewController, UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate {
    //페이지 번호와 크기
    var currentPage = 0
    
    //게시글을 저장시킬 테이블 뷰 생성
    let tableView = UITableView()
    let activityIndicator = UIActivityIndicatorView(style: .large) // 로딩 인디케이터 뷰
    var posts : [Post] = [
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
    //cellForRowAt 메서드 각 셀에 해당하는 게시물의 제목 표시
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let post = posts[indexPath.row]
        cell.titleLabel.text = post.title
        cell.commentLabel.text = post.content
        cell.DayLabel.text = post.day
        // 이미지 뷰 초기화 또는 placeholder 이미지 설정
        cell.postImageView.image = UIImage(named: "placeholderImage")
        //MARK: - URL to Image Conversion
        // 첫 번째 이미지가 nil이면 안함.
        if !post.images.isEmpty {
                let firstImageIndex = 0
                if firstImageIndex < post.images.count {
                    let imageUrlString = post.images[firstImageIndex].imageUrl
                    if !imageUrlString.isEmpty, let imageUrl = URL(string: imageUrlString) {
                        cell.postImageView.kf.setImage(with: imageUrl) { result in
                            switch result {
                            case .success(_):
                                // 이미지 로딩이 완료된 후에 현재 셀의 인덱스와 indexPath.row를 비교하여 이미지를 설정
                                if let visibleIndexPaths = tableView.indexPathsForVisibleRows, visibleIndexPaths.contains(indexPath) {
                                    tableView.reloadRows(at: [indexPath], with: .none)
                                }
                            case .failure(_):
                                break // 이미지 로딩 실패 시 처리
                            }
                        }
                    }
                }
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
        let Alert = UIAlertController(title: "글 작성 메뉴", message: nil, preferredStyle: .alert)
        let Open = UIAlertAction(title: "자유게시판", style: .default){
            (_) in
            self.navigationController?.pushViewController(OpenWriteViewController(), animated: true)
        }
        let Vote = UIAlertAction(title: "투표", style: .default){ (_) in
            self.navigationController?.pushViewController(VoteBoardWriteViewController(boardType: "Free"), animated: true)
        }
        let Ok = UIAlertAction(title: "취소", style: .default){ (_) in
        }
        Alert.addAction(Open)
        Alert.addAction(Vote)
        Alert.addAction(Ok)
        present(Alert, animated: true)
    }
    //MARK: - 서버에서 데이터 가져오기
    var isLoading = false  // 중복 로드 방지를 위한 플래그
    func fetchPosts(page: Int, completion: @escaping ([Post]?, Error?) -> Void) {
        let url = URL(string: "https://keep-ops.shop/api/v1/boards?page=\(page)&boardType=Free")!
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
                    var posts = [Post]()
                    for board in boards {
                        if let title = board["title"] as? String,
                           let content = board["content"] as? String,
                           let boardId = board["boardId"] as? Int,
                           let imagesArray = board["images"] as? [[String: Any]],
                           let day = board["createdTime"] as? String
                        {
                            var images = [Post.Images]()
                            for imageInfo in imagesArray {
                                if let imageName = imageInfo["imageName"],
                                    let imageUrl = imageInfo["imageUrl"] {
                                    let image = Post.Images(imageName: imageName as! String, imageUrl: imageUrl as! String)
                                    images.append(image)
                                }
                            }
                            let post = Post(boardId: boardId, title: title, content: content, images: images, day: day, page:page)
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
                activityIndicator.startAnimating() // 로딩 인디케이터 시작
                loadNextPage()
            }
        } else if !isScrollingDown && contentOffsetY < threshold {
            if !updatePageCalled { //호출되지 않은 경우에만 실행
                updatePageCalled = true // 호출되었다고 표시
                self.view.addSubview(activityIndicator)
                activityIndicator.startAnimating() // 로딩 인디케이터 시작
                updatePage()
            }
        }
    }
    //새로운 페이지 새로고침
    @objc func updatePage() {
        print("updatePage() - called")
        if isLoading {
                return // 이미 로딩 중이면 중복 로딩 방지
            }
            
        isLoading = true
        currentPage = 0 //처음 페이지부터 다시 시작
        //스크롤을 감지해서 인디케이터가 시작되면 종료가 되면 로딩인디케이터를 멈처야함
        // 서버에서 다음 페이지의 데이터를 가져옴
        fetchPosts(page: currentPage) { [weak self] (newPosts, error) in
            guard let self = self else { return }
            self.isLoading = false // 로딩 완료
            // 데이터를 비워줌
            self.posts.removeAll()
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
        if isLoading {
                return // 이미 로딩 중이면 중복 로딩 방지
            }
        isLoading = true
        //스크롤을 감지해서 인디케이터가 시작되면 통신이 완료되면 종료해야함.

        fetchPosts(page: currentPage) { [weak self] (newPosts, error) in
            guard let self = self else { return }
            self.isLoading = false // 로딩 완료
            if let newPosts = newPosts {
                self.posts += newPosts
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
    // 뷰 컨트롤러가 부모로 이동될 때 호출
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
            if isMovingFromParent {
                // 해당 뷰 컨트롤러가 부모로부터 제거될 때 실행됩니다.
                navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            }
    }
}
