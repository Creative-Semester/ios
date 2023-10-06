//
//  PostDetailViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/07/30.
//

import Foundation
import UIKit
import SnapKit
import SwiftKeychainWrapper
import Kingfisher //url - > image 변환 라이브러리
//게시글의 구조체 정의(게시물을 정보를 담기 위함)
//댓글 창
struct Comment : Decodable{
    let day : String // 생성 날짜
    let commentId : Int // 댓글 고유 ID
    let comment : String // 댓글 내용
    let commentIsMine : Bool // 내 댓글인지 확인
}
//게시물의 상세 내용을 보여주는 UIViewController
class PostDetailViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    var CommentTableView = UITableView()
    private let GreatBtn = UIButton()
    let activityIndicator = UIActivityIndicatorView(style: .large) // 로딩 인디케이터 뷰
    //페이지 번호와 크기
    var currentPage = 0
    //해당 게시글 작성자와 사용자가 동일한지 비교하기 위해 전역변수 선언
    var IsMine = false
    // 댓글을 저장할 배열
    var comments : [Comment] = [
    ]
    let post : Post
    //이니셜라이저를 사용하여 Post 객체를 전달받아 post 속성에 저장
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 댓글창 입력 전역변수
    var commentField = ExpandingTextView()
    var vview = UIView()
    var ScrollView = UIScrollView()
    var StackView = UIStackView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .red
        CommentTableView.estimatedRowHeight = 100 // 예상 높이 (원하는 초기 높이)
        CommentTableView.rowHeight = UITableView.automaticDimension
        BoardDetailShow() // 게시글의 사용자와 작성자를 비교하기 위한 메서드 호출
        // 로딩 인디케이터 뷰 초기 설정
        activityIndicator.color = .gray
        activityIndicator.center = view.center
        // 처음에 초기 데이터를 불러옴
        fetchPosts(page: currentPage) { [weak self] (newPosts, error) in
                guard let self = self else { return }
                
                if let newPosts = newPosts {
                    // 초기 데이터를 posts 배열에 추가
                    self.comments += newPosts
                    // 테이블 뷰 갱신
                    DispatchQueue.main.async {
                        self.CommentTableView.reloadData()
                        print("처음 가져오고 난 후 comments의 배열입니다. - \(self.comments)")
                    }
                    print("Initial data fetch - Success")
                } else if let error = error {
                    // 오류 처리
                    print("Error fetching initial data: \(error.localizedDescription)")
                }
            }
        title = post.title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let toolBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(toolBtnTapped))
        navigationItem.rightBarButtonItem = toolBtn
        vview = UIView()
        vview.backgroundColor = .white
        vview.layer.borderWidth = 0.2
        
        //댓글 입력 창과 버튼을 추가
        commentField = ExpandingTextView()
        commentField.backgroundColor =  #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        commentField.layer.cornerRadius = 10
        commentField.layer.masksToBounds = true
        commentField.font = UIFont.boldSystemFont(ofSize: 17)
        //Snapkit을 이용한 오토레이아웃
        vview.addSubview(commentField)
        commentField.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(self.view.frame.width / 1.4)
            make.height.greaterThanOrEqualTo(self.view.frame.height / 21) // 최소 높이
            make.height.lessThanOrEqualTo(self.view.frame.height / 11) // 최대 높이
        }
        let CommentBtn = UIButton()
        CommentBtn.backgroundColor =  #colorLiteral(red: 0.9744978547, green: 0.7001121044, blue: 0.6978833079, alpha: 1)
        CommentBtn.layer.cornerRadius = 10
        CommentBtn.layer.masksToBounds = true
        let iconImage = UIImage(systemName: "message")
        CommentBtn.setImage(iconImage, for: .normal)
        CommentBtn.tintColor = .black
        CommentBtn.addTarget(self, action: #selector(CommentBtnTapped), for: .touchUpInside)
        vview.addSubview(CommentBtn)
        //SnapKit을 이용한 오토레이아웃 설정
        CommentBtn.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(self.view.frame.width / 5)
            make.height.equalTo(self.view.frame.height / 20)
        }
        self.view.addSubview(vview)
        vview.snp.makeConstraints{ (make) in
            make.height.equalTo(self.view.frame.height / 9)
            make.leading.trailing.equalToSuperview().inset(0)
            make.bottom.equalToSuperview()
        }
        setupView()
        setupTapGesture()
    }
    func setupView(){
        //각 뷰들을 넣을 스크롤뷰 생성
        ScrollView.backgroundColor = .white
        ScrollView.isScrollEnabled = true
        ScrollView.showsHorizontalScrollIndicator = true
        //스택뷰를 이용해 오토레이아웃 설정
        StackView.axis = .vertical
        StackView.distribution = .fill
        StackView.alignment = .fill
        StackView.spacing = 20
        
        //게시물의 상세내용을 넣을 뷰
        let DetailView = UIView()
        DetailView.backgroundColor = .white
        let DetailLabel = UILabel()
        DetailLabel.text = post.content
        DetailLabel.textColor = .black
        DetailLabel.font = UIFont.boldSystemFont(ofSize: 18)
        DetailView.addSubview(DetailLabel)
        DetailLabel.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(0)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(40)
        }
        //이미지를 넣을 뷰
        let ImageStackView = UIStackView()
        ImageStackView.spacing = 10
        ImageStackView.axis = .vertical
        ImageStackView.distribution = .fill
        ImageStackView.backgroundColor = .white
        let ImageView = UIImageView()
        print("post.image가 nil인가? : \(String(describing: post.images.imageUrl.isEmpty))") //수정필요
        if(post.images.imageUrl.isEmpty) { //수정필요
            print("post.image가 nil인데 화면의 크기의 조정이 필요합니다.")
        }else{
            // 게시글의 이미지 URL 배열에서 이미지를 가져와 처리
            for imageUrlStsring in post.images.imageUrl {//수정필요
                if let imageUrl = URL(string: imageUrlStsring as? String ?? ""){
                    print("이미지들 Url 입니다. - \(imageUrl)")
                    // Kingfisher를 사용하여 이미지를 다운로드하고 처리
                    let imageView = UIImageView()
                    imageView.kf.setImage(with: imageUrl)
                    
                    imageView.contentMode = .scaleAspectFit
                    imageView.backgroundColor = .white
                    
                    // 이미지 뷰를 스택뷰에 추가
                    ImageStackView.addArrangedSubview(imageView)
                    // 이미지 뷰에 오토레이아웃 설정
                    ImageView.snp.makeConstraints{ (make) in
                        make.height.equalTo(200)
                    }
                }
            }
            DetailView.addSubview(ImageStackView)
            // 오토레이아웃 설정
            ImageStackView.snp.makeConstraints { (make) in
                make.top.equalTo(DetailLabel.snp.bottom).offset(10)
                make.trailing.equalToSuperview().offset(-40)
                make.leading.equalToSuperview().offset(30)
                    }
        }
        //게시물의 댓글을 나열 할 뷰
        CommentTableView.backgroundColor = .white
        CommentTableView.delegate = self
        CommentTableView.dataSource = self
        CommentTableView.frame = view.bounds
        CommentTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        CommentTableView.showsHorizontalScrollIndicator = false
        CommentTableView.isScrollEnabled = false
        CommentTableView.register(CustomCommentTableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        StackView.addArrangedSubview(DetailView)
        StackView.addArrangedSubview(CommentTableView)
        ScrollView.addSubview(StackView)
        ScrollView.delegate = self
        self.view.addSubview(ScrollView)
        //SnapKit을 이용한 오토레이아웃 설정
        ScrollView.snp.makeConstraints{ (make) in
            make.bottom.equalToSuperview().offset(-self.view.frame.height / 8.5)
            make.top.equalToSuperview().offset(self.view.frame.height / 8.5)
            make.trailing.leading.equalToSuperview().inset(0)
        }
        StackView.snp.makeConstraints{ (make) in
            if (comments.count < 5 && post.images.imageUrl.isEmpty) {
                make.height.equalTo(ScrollView.snp.height)
                make.bottom.equalToSuperview().offset(-10)
            }else if(post.images.imageUrl.isEmpty){ // 수정필요
                print("post.image가 nil이기 때문에 크기가 조정됩니다.")
                make.height.equalTo(DetailLabel.frame.height + CGFloat((comments.count + 2) * 100))
                make.bottom.equalToSuperview().offset(-0)
            }else{
                make.height.equalTo(DetailLabel.frame.height + ImageStackView.frame.height + CGFloat((comments.count + 4)
                                                                                                     * 100))
                
                make.bottom.equalToSuperview().offset(-0)
            }
            make.width.equalTo(ScrollView.snp.width)
            make.top.equalToSuperview().offset(0)
        }
        DetailView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(20)
            if(post.images.imageUrl.isEmpty){ //수정필요
                print("post.image가 nil이기 때문에 크기가 조정됩니다.")
                make.height.equalTo(DetailLabel.frame.height + 100)
            }else{
                make.height.equalTo(DetailLabel.frame.height + ImageStackView.frame.height + 300)
            }
            make.leading.equalToSuperview().offset(20)
        }
        CommentTableView.snp.makeConstraints{ (make) in
            make.top.equalTo(DetailView.snp.bottom).offset(0)
            make.leading.trailing.equalToSuperview().inset(0)
            make.bottom.equalToSuperview().offset(0)
        }
        // 댓글 입력 필드에 대한 Notification Observer 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //화면의 다른 곳을 눌렀을 때 가상키보드가 사라짐
    func setupTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            self.view.addGestureRecognizer(tapGesture)
    }
    @objc func handleTap() {
        self.view.endEditing(true) // 키보드가 열려있을 경우 닫기
    }
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            adjustCommentView(insets: contentInsets)
            let newSize = commentField.sizeThatFits(CGSize(width: commentField.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            let size = CGSize(width: commentField.frame.size.width, height: self.view.frame.height / 11)
            if(commentField.text.isEmpty){
                commentField.snp.remakeConstraints { (make) in
                                make.top.equalToSuperview().offset(10)
                                make.leading.equalToSuperview().offset(10)
                                make.width.equalTo(self.view.frame.width / 1.4)
                                make.height.greaterThanOrEqualTo(self.view.frame.height / 21) // 최소 높이
                                make.height.lessThanOrEqualTo(self.view.frame.height / 11) // 최대 높이
                            }
            }else{
                commentField.selectedRange = NSMakeRange(commentField.text.count, 0)
                commentField.scrollRangeToVisible(commentField.selectedRange)
                commentField.snp.remakeConstraints { (make) in
                                make.top.equalToSuperview().offset(10)
                                make.leading.equalToSuperview().offset(10)
                                make.width.equalTo(self.view.frame.width / 1.4)
                                if(newSize.height > size.height){
                                    make.height.equalTo(self.view.frame.height / 11)
                                }else{
                                    make.height.equalTo(newSize.height)
                                }
                }
            }
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        adjustCommentView(insets: contentInsets)
        commentField.selectedRange = NSMakeRange(0, 0)
        commentField.scrollRangeToVisible(commentField.selectedRange)
        commentField.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(self.view.frame.width / 1.4)
            make.height.equalTo(self.view.frame.height / 21) // 최소 높이
        }
    }

    private func adjustCommentView(insets: UIEdgeInsets) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.view.frame.origin.y = -insets.bottom
        }
    }
    //게시글의 툴버튼을 눌렀을 때 팝업
    @objc func toolBtnTapped() {
        let alertController = UIAlertController(title: "게시글 메뉴", message: nil, preferredStyle: .alert)
        let isMyPost = true //게시글의 작성자와 현재 사용자가 동일한지 판별
        //ismine으로 수정해야함.
        print("해당 게시물이 내 게시글인지 확인 - \(IsMine)")
        //게시글의 작성자와 현재 사용자가 같을때
        if IsMine {
                    // 삭제
            let deleteAction = UIAlertAction(title: "삭제", style: .default) { (_) in
                self.PostDelete()
                    }
            alertController.addAction(deleteAction)
        }else{ //게시글의 작성자와 현재 사용자가 다를때
            //쪽지 보내기
            let SendMessageController = UIAlertAction(title: "쪽지 보내기", style: .default) { (_) in
                // '쪽지' 버튼을 눌렀을 대의 동작을 구현
            }
            alertController.addAction(SendMessageController)
            //신고
//            let DeclarationController = UIAlertAction(title: "신고", style: .default) { (_) in
//
//            }
//            alertController.addAction(DeclarationController)
        }
        //취소
        let CancelController = UIAlertAction(title: "취소", style: .default) { (_) in
            
        }
        alertController.addAction(CancelController)
        present(alertController, animated: true)
    }
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomCommentTableViewCell
        let comment = comments[indexPath.row]
        cell.commentLabel.text = comment.comment
        cell.DayLabel.text = comment.day
        cell.commentLabel.sizeToFit()
        // 업데이트가 완료된 후에 이 부분에서 셀 정보를 확인할 수 있습니다.
        let cellText = cell.commentLabel.text ?? "No Text"
        print("Cell at section \(indexPath.section), row \(indexPath.row): \(cellText)")
        return cell
    }
    // MARK: - UITableViewDelegate
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    //댓글을 눌렀을때 팝업
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "댓글 메뉴", message: nil, preferredStyle: .alert)
        //댓글 조회를 통해 아이디를 가져와 해당 셀이 ismine인지 판별
        let comment = comments[indexPath.row]
        //댓글 작성자와 현재 사용자가 같을때
        if comment.commentIsMine {// 삭제
            let deleteAction = UIAlertAction(title: "삭제", style: .default) { (_) in
                self.CommentDelete(commentId: comment.commentId) //댓글 삭제 메서드
                    }
            alertController.addAction(deleteAction)
        }else{ //게시글의 작성자와 현재 사용자가 다를때
            //쪽지 보내기
            let SendMessageController = UIAlertAction(title: "쪽지 보내기", style: .default) { (_) in
                // '쪽지' 버튼을 눌렀을 대의 동작을 구현
            }
            alertController.addAction(SendMessageController)
            //신고
            let DeclarationController = UIAlertAction(title: "신고", style: .default) { (_) in
                self.CommentDeclaration(commentId: comment.commentId) //댓글 신고 메서드
            }
            alertController.addAction(DeclarationController)
        }
        //취소
        let CancelController = UIAlertAction(title: "취소", style: .default) { (_) in
            
        }
        alertController.addAction(CancelController)
        present(alertController, animated: true)
    }
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
        currentPage = 0 //처음 페이지부터 다시 시작
        //스크롤을 감지해서 인디케이터가 시작되면 종료가 되면 로딩인디케이터를 멈처야함
        // 서버에서 다음 페이지의 데이터를 가져옴
        fetchPosts(page: currentPage) { [weak self] (newPosts, error) in
            guard let self = self else { return }
            // 데이터를 비워줌
            self.comments.removeAll()
            if let newPosts = newPosts {
                // 새로운 데이터를 기존 데이터와 병합
                self.comments += newPosts
                print("갱신된 댓글 테이블입니다 - \(self.comments)")
                // 테이블 뷰 갱신
                DispatchQueue.main.async {
                    self.CommentTableView.reloadData()
                    self.StackView.snp.remakeConstraints{ (make) in
                        if (self.comments.count < 5 && self.post.images.imageUrl.isEmpty) {
                            make.height.equalTo(self.ScrollView.snp.height)
                            make.bottom.equalToSuperview().offset(-10)
                        }else if(self.post.images.imageUrl.isEmpty){ // 수정필요
                            print("post.image가 nil이기 때문에 크기가 조정됩니다.")
                            make.height.equalTo(CGFloat((self.comments.count + 2) * 100))
                            make.bottom.equalToSuperview().offset(-0)
                        }else{
                            make.height.equalTo( CGFloat((self.comments.count + 4) * 100))
                            make.bottom.equalToSuperview().offset(-0)
                        }
                        make.width.equalTo(self.ScrollView.snp.width)
                        make.top.equalToSuperview().offset(0)
                    }
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
        //스크롤을 감지해서 인디케이터가 시작되면 통신이 완료되면 종료해야함.

        fetchPosts(page: currentPage) { [weak self] (newPosts, error) in
            guard let self = self else { return }
            if let newPosts = newPosts {
                self.comments += newPosts
                // 테이블뷰 갱신
                DispatchQueue.main.async {
                    self.CommentTableView.reloadData()
                    self.StackView.snp.remakeConstraints{ (make) in
                        if (self.comments.count < 5 && self.post.images.imageUrl.isEmpty) {
                            make.height.equalTo(self.ScrollView.snp.height)
                            make.bottom.equalToSuperview().offset(-10)
                        }else if(self.post.images.imageUrl.isEmpty){ // 수정필요
                            print("post.image가 nil이기 때문에 크기가 조정됩니다.")
                            make.height.equalTo(CGFloat((self.comments.count + 2) * 100))
                            make.bottom.equalToSuperview().offset(-0)
                        }else{
                            make.height.equalTo( CGFloat((self.comments.count + 4) * 100))
                            make.bottom.equalToSuperview().offset(-0)
                        }
                        make.width.equalTo(self.ScrollView.snp.width)
                        make.top.equalToSuperview().offset(0)
                    }
                }
                print("loadNextPage - Success")
            } else if let error = error {
                print("Error fetching next page: \(error.localizedDescription)")
            }
            // 로딩 인디케이터 멈춤
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
            }
            self.loadNextPageCalled = false // 데이터가 로드되었으므로 호출 플래그 초기화
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
//UITextView 서브클래스 정의
class ExpandingTextView: UITextView {
    //UITextView의 내용의 크기, 텍스트가 입력 될때마다 내용 크기가 변경
    override var contentSize: CGSize {
        //변경 감지를 위해 didSet
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    //UIView의 내용의 크기 : 다른 레이아웃 구성요소, 해당 뷰의 적절한 크기를 알려줌
    override var intrinsicContentSize: CGSize {
        //noIntrinsicMetric 텍스트 뷰의 폭이 무제한, 높이는 내용에 따라 자동 조절
        let size = CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
        return size
    }
}
extension PostDetailViewController {
    //MARK: - 서버에서 데이터 가져오기 -> 댓글 조회
    func fetchPosts(page: Int, completion: @escaping ([Comment]?, Error?) -> Void) {
        let url = URL(string: "http://15.164.161.53:8082/api/v1/boards/\(post.boardId)/comment?page=\(post.page)")!
        if AuthenticationManager.isTokenValid(){}else{} //토큰 유효성 검사
        let acToken = KeychainWrapper.standard.string(forKey: "AuthToken")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(acToken, forHTTPHeaderField: "accessToken")

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
                if let result = json?["result"] as? [String: Any], let comments = result["commentList"] as? [[String: Any]] {
                    var posts = [Comment]()
                    for comment in comments {
                        if
                            let day = comment["createdTime"] as? String,
                            let commentId = comment["id"] as? Int,
                            let commentText = comment["text"] as? String,
                            let isMine = comment["isMine"] as? Bool
                        {
                            let post = Comment(day: day, commentId: commentId, comment: commentText, commentIsMine: isMine)
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
    //게시글 상세 조회 -> ismine일 경우에 처리해야함. studentNum, boardid
    @objc func BoardDetailShow() {
        print("BoardDetailShow() - called()")
        // 서버 API 엔드포인트 및 요청 생성
        let apiUrl = URL(string: "http://15.164.161.53:8082/api/v1/boards/\(post.boardId)")
        var request = URLRequest(url: apiUrl!)
        request.httpMethod = "GET"
        if AuthenticationManager.isTokenValid(){}else{} //토큰 유효성 검사
        let acToken = KeychainWrapper.standard.string(forKey: "AuthToken")
        //헤더와 인증토큰 설정
        request.setValue(acToken, forHTTPHeaderField: "accessToken")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //서버로 요청 보내기
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // 서버 응답 처리
            if let error = error {
                    print("Error: \(error.localizedDescription)")
            } else if let data = data {
            // 서버 응답 데이터 처리
            if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            // 서버로부터 받은 JSON 데이터 처리
                print("Response JSON: \(responseJSON)")
                // 형식은 수정해줘야함.
                if let result = responseJSON["result"] as? [String: Any],
                   let ismine = result["isMine"] as? Bool{
                     self.IsMine = ismine //게시글 작성자와 사용자가 동일한지 판별
                    }
                }else{ print("게시글 상세내용 조회 - JSON 파싱 오류") }
            }
        }.resume()
    }
    //댓글 작성 메서드
    @objc func CommentBtnTapped() {
        print("CommentBtnTapped - called()")
        var status = 0
        guard let commentText = commentField.text, !commentText.isEmpty else{
            return // 댓글 내용이 비어 있으면 아무 작업도 하지 않음
        }
        // 서버 API 엔드포인트 및 요청 생성
        let apiUrl = URL(string: "http://15.164.161.53:8082/api/v1/boards/\(post.boardId)/comment")
        var request = URLRequest(url: apiUrl!)
        request.httpMethod = "POST"
        let body : [String : Any] = [
            "text" : commentText
        ]
        if let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []){
            request.httpBody = jsonData
        }
        if AuthenticationManager.isTokenValid(){}else{} //토큰 유효성 검사
        let acToken = KeychainWrapper.standard.string(forKey: "AuthToken")
        //헤더와 인증토큰 설정
        request.setValue(acToken, forHTTPHeaderField: "accessToken")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //서버로 요청 보내기
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // 서버 응답 처리
            if let error = error {
                    print("Error: \(error.localizedDescription)")
            } else if let data = data {
            // 서버 응답 데이터 처리 (만약 필요하다면)
            if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            // 서버로부터 받은 JSON 데이터 처리
                print("Response JSON: \(responseJSON)")
                status = responseJSON["status"] as? Int ?? 0
                }
            }
            if status == 200 {
                // 테이블 뷰 업데이트 (메인 스레드에서 실행해야 함)
                print("댓글 전송이 성공했습니다. 테이블뷰를 reloadData 할게요.")
                DispatchQueue.main.async {
                    self.commentField.text = ""
                    self.CommentTableView.reloadData()
                }
            }
        }.resume()
    }
    //게시글 삭제 메서드
    func PostDelete() {
        print("PostDelete - called()")
        var status = 200
        // 서버에 삭제 요청을 보내는 예시
        guard let url = URL(string: "http://15.164.161.53:8082/api/v1/boards/\(post.boardId)") else { return }
        print("삭제하려는데 몇번 게시물인가요? - \(post.boardId)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        if AuthenticationManager.isTokenValid(){}else{} //토큰 유효성 검사
        // 인증 헤더 또는 토큰을 추가
        let acToken = KeychainWrapper.standard.string(forKey: "AuthToken")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(acToken, forHTTPHeaderField: "accessToken")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                        print("Response: \(jsonResponse)")
                        status = jsonResponse["status"] as? Int ?? 0
                    }
                }catch {
                    
                }
            }
            if status == 200 {
                DispatchQueue.main.async {
                    // 삭제가 성공하면 화면에서 업데이트 필요 >> 메인스레드에서 reload.data 필요
                    let DeleteAlertController = UIAlertController(title: nil, message: "게시글이 삭제 되었습니다.", preferredStyle: .alert)
                    let CancelController = UIAlertAction(title: "확인", style: .default) { (_) in
                        // 게시글이 삭제되면 Alert 팝업창과 함께 메인으로 돌아갑니다.
                        if let navigationController = self.navigationController {
                                    navigationController.popViewController(animated: true)
                                }
                    }
                    DeleteAlertController.addAction(CancelController)
                    self.present(DeleteAlertController, animated: true)
                    // 게시글이 삭제되면 Alert 팝업창과 함께 메인으로 가서 reload.data해야함.
                }
            }else{
                print("게시글 삭제 실패")
            }
        }
        task.resume()
    }
    //게시글 신고 메서드
    func PostDeclaration() {
        print("PostDeclaration - called()")
    }
    //댓글 삭제 메서드
    func CommentDelete(commentId : Int) {
        print("CommentDelete - called()")
        var status = 200
        // 서버에 삭제 요청을 보내는 예시
        guard let url = URL(string: "http://15.164.161.53:8082/api/v1/comment/\(commentId)") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        // 인증 헤더 또는 토큰을 추가
        if AuthenticationManager.isTokenValid(){}else{} //토큰 유효성 검사
        // 인증 헤더 또는 토큰을 추가
        let acToken = KeychainWrapper.standard.string(forKey: "AuthToken")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(acToken, forHTTPHeaderField: "accessToken")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                        print("Response: \(jsonResponse)")
                        status = jsonResponse["status"] as? Int ?? 0
                    }
                }catch {
                    
                }
            }
            if status == 200 {
                DispatchQueue.main.async {
                    // 삭제가 성공하면 화면에서 업데이트 필요 >> 메인스레드에서 reload.data 필요
                    let DeleteAlertController = UIAlertController(title: nil, message: "댓글이 삭제 되었습니다.", preferredStyle: .alert)
                    let CancelController = UIAlertAction(title: "확인", style: .default) { (_) in
                    }
                    DeleteAlertController.addAction(CancelController)
                    self.present(DeleteAlertController, animated: true)
                }
            }else{
                print("댓글 삭제 실패")
            }
            // 테이블뷰 갱신
            DispatchQueue.main.async {
                self.CommentTableView.reloadData()
            }
        }
        task.resume()
    }
    //댓글 신고 메서드
    func CommentDeclaration(commentId : Int) {
        print("CommentDeclaration - called()")
        var status = 200
        // 서버에 삭제 요청을 보내는 예시
        guard let url = URL(string: "http://15.164.161.53:8082/api/v1/comment/\(commentId)/report") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // 인증 헤더 또는 토큰을 추가
        if AuthenticationManager.isTokenValid(){}else{} //토큰 유효성 검사
        // 인증 헤더 또는 토큰을 추가
        let acToken = KeychainWrapper.standard.string(forKey: "AuthToken")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(acToken, forHTTPHeaderField: "accessToken")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                        print("Response: \(jsonResponse)")
                        status = jsonResponse["status"] as? Int ?? 0
                    }
                }catch {
                    
                }
            }
            if status == 200 {
                DispatchQueue.main.async{
                    // 삭제가 성공하면 화면에서 업데이트 필요 >> 메인스레드에서 reload.data 필요
                    let DeleteAlertController = UIAlertController(title: nil, message: "댓글이 신고 되었습니다.", preferredStyle: .alert)
                    let CancelController = UIAlertAction(title: "확인", style: .default) { (_) in
                    }
                    DeleteAlertController.addAction(CancelController)
                    self.present(DeleteAlertController, animated: true)
                }
            }else{
                print("댓글 신고 실패")
            }
        }
        task.resume()
    }
}
