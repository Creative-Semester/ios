//
//  MyWriteViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/09/19.
//

import Foundation
import UIKit
import SnapKit
import SwiftKeychainWrapper
import Kingfisher //url - > image 변환 라이브러리
//게시글의 구조체 정의(게시물을 정보를 담기 위함)
struct MyWritePost: Decodable {
    let boardId: Int
    let title: String
    let content: String
    let images: [Images]
    let day: String
    let page: Int
    let boardType : String
    struct Images: Decodable {
        let imageName: String
        let imageUrl: String
    }
}
class MyWriteViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    //페이지 번호와 크기
    var currentPage = 0
    var totalPage = 1
    var detailViewController = UIViewController()
    //내가 쓴 글에 대해서 보여줄 TableView 전역 선언
    let tableView = UITableView()
    var posts : [MyWritePost] = [
    ]
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super .viewDidLoad()
        self.view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .red
        title = "내가 쓴 글"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        setupTableView()
        refreshControl.addTarget(self, action: #selector(refreshtableView), for: .valueChanged)
        tableView.refreshControl = refreshControl
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.frame = view.bounds
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //UITableView에 셀 등록
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    // MARK: - UITableViewDataSource
    @objc func refreshtableView() {
        updatePage()
        tableView.refreshControl?.endRefreshing()
    }
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
        let postboardType = post.boardType
        showPostDetail(post: post, boardType: postboardType)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    //셀을 선택했을 때 해당 게시물의 상세 내용을 보여주기 위함
    func showPostDetail(post: MyWritePost, boardType: String){
            let detailViewController = MyWriteVoteViewController(post: post)
            //게시글의 상세 글 볼때 탭바 숨기기
            tabBarController?.tabBar.isHidden = true
            navigationController?.pushViewController(detailViewController, animated: true)
//        if boardType == "Free" {
//            let detailViewController = MyWriteDetailViewController(post: post)
//            //게시글의 상세 글 볼때 탭바 숨기기
//            tabBarController?.tabBar.isHidden = true
//            navigationController?.pushViewController(detailViewController, animated: true)
//        }else{
//            let detailViewController = MyWriteVoteViewController(post: post)
//            //게시글의 상세 글 볼때 탭바 숨기기
//            tabBarController?.tabBar.isHidden = true
//            navigationController?.pushViewController(detailViewController, animated: true)
//        }
    }
    //MARK: - 서버에서 데이터 가져오기
    var isLoading = false  // 중복 로드 방지를 위한 플래그
    func fetchPosts(page: Int, completion: @escaping ([MyWritePost]?, Error?) -> Void) {
        guard let url = URL(string: "https://keep-ops.shop/api/v1/user/boards?page=\(page)") else { return }
        if AuthenticationManager.isTokenValid(){}else{} //토큰 유효성 검사
        let acToken = KeychainWrapper.standard.string(forKey: "AuthToken")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(acToken, forHTTPHeaderField: "accessToken")
        let page = currentPage
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
                if let result = json?["result"] as? [String: Any], let total = result["totalPage"] as? Int,
                   let current = result["currentPage"] as? Int,
                   let boards = result["boardList"] as? [[String: Any]] {
                    self.totalPage = total
                    self.currentPage = current
                    var posts = [MyWritePost]()
                    for board in boards {
                        if let title = board["title"] as? String,
                           let content = board["content"] as? String,
                           let boardId = board["boardId"] as? Int,
                           let imagesArray = board["images"] as? [[String: Any]],
                           let day = board["createdTime"] as? String,
                           let boardType = board["boardType"] as? String
                        {
                            var images = [MyWritePost.Images]()
                            for imageInfo in imagesArray {
                                if let imageName = imageInfo["imageName"],
                                    let imageUrl = imageInfo["imageUrl"] {
                                    let image = MyWritePost.Images(imageName: imageName as! String, imageUrl: imageUrl as! String)
                                    images.append(image)
                                }
                            }
                            let post = MyWritePost(boardId: boardId, title: title, content: content, images: images, day: day, page:page, boardType: boardType)
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.frame.height
        
        // 스크롤이 맨 아래에 도달했을 때 새로운 페이지의 정보를 받습니다.
        if offsetY + contentHeight >= screenHeight && currentPage < totalPage {
            print("현재 페이지 : \(currentPage),\n전체 페이지 : \(totalPage)")
            loadNextPage()
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
        }
    }
    //스크롤이 아래로 내려갈때 기존페이지 + 다음 페이지 로드
    func loadNextPage() {
        print("loadNextPage() - called")
        currentPage += 1
        fetchPosts(page: currentPage) { [weak self] (newPosts, error) in
            guard let self = self else { return }
//            self.isLoading = false // 로딩 완료
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
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            //부모로 이동했을때 탭바를 다시 켬
            if isMovingFromParent {
                print("Back 버튼 클릭됨")
                tabBarController?.tabBar.isHidden = false
            }
        }
}
