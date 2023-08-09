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
    
}
//UITableViewDataSource, UITableViewDelegate 테이블뷰와 데이터를 연결
class DepartBoardViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    //게시글을 저장시킬 테이블 뷰 생성
    let tableView = UITableView()
    let departposts : [DepartPost] = [
        DepartPost(title: "첫 번째 게시물", content: "첫 번째 게시물 내용입니다."),
        DepartPost(title: "두 번째 게시물", content: "두 번째 게시물 내용입니다."),
        DepartPost(title: "세 번째 게시물", content: "세 번째 게시물 내용입니다.")
    ]
    override func viewDidLoad() {
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.tintColor = .red
        title = "자유게시판"
        setupTableView()
        //글쓰기 버튼을 상단 바에 추가
        let addButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(WriteBtnTappend))
        navigationItem.leftBarButtonItem = addButton
        //게시글을 검색하는 버튼을 생성
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(SearchBtnTapped))
        navigationItem.rightBarButtonItem = searchButton
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
        return departposts.count
    }
    //cellForRowAt 메서드 각 셀에 해당하는 개시물의 제목 표시
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let post = departposts[indexPath.row]
        cell.titleLabel.text = post.title
        cell.commentLabel.text = post.content
        
        return cell
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
        let detailViewController = PostDetailViewController(post: post)
        //게시글의 상세 글 볼때 탭바 숨기기
        tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    //글쓰기 버튼을 누르면 글작성 뷰로 이동시킬 메서드
    @objc func WriteBtnTappend() {
        navigationController?.pushViewController(OpenWriteViewController(), animated: true)
    }
    @objc func SearchBtnTapped() {
        let alertController = UIAlertController(title: "검색", message: nil, preferredStyle: .alert)
        // 검색어를 입력 받을 텍스트 필드 추가
        alertController.addTextField() { (textField) in
            textField.placeholder = "검색어를 입력하세요"
        }
                // '취소' 버튼 추가
                let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)

                // '검색' 버튼 추가
                let searchAction = UIAlertAction(title: "검색", style: .default) { (_) in
                    // '검색' 버튼을 눌렀을 때의 동작을 구현 (예: 검색 기능 실행)
                }
                alertController.addAction(searchAction)

                // 팝업 표시
                present(alertController, animated: true, completion: nil)
    }
}
