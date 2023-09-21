//
//  PostDetailViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/07/30.
//

import Foundation
import UIKit
//댓글 창
struct Comment {
    let comment : String
}
struct User: Codable {
    let userId: String // 사용자 아이디에 맞는 속성을 추가
    // 다른 사용자 정보 속성들도 추가할 수 있습니다
}
//게시물의 상세 내용을 보여주는 UIViewController
class PostDetailViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    var CommentTableView = UITableView()
    private let GreatBtn = UIButton()
    //현재 게시물의 작성자를 전역변수로 선언
    var userIdOfAuthor : String = ""
    //현재 로그인한 사용자의 사용자 ID
    var currentUserId : String = ""
    // 댓글을 저장할 배열
    let comments : [Comment] = [
        Comment(comment: "첫 번째 댓글입니다"),
        Comment(comment: "두 번째 댓글입니다"),
        Comment(comment: "세 번째 댓글입니다"),
        Comment(comment: "네 번째 댓글입니다"),
        Comment(comment: "5 번째 댓글입니다"),
        Comment(comment: "6 번째 댓글입니다"),
        Comment(comment: "7 번째 댓글입니다"),
        Comment(comment: "8 번째 댓글입니다"),
        Comment(comment: "9 번째 댓글입니다"),
        Comment(comment: "10 번째 댓글입니다")
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
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .red
        title = post.title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let toolBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(toolBtnTapped))
        navigationItem.rightBarButtonItem = toolBtn
        
        setupView()
        setupTapGesture()
    }
    func setupView(){
        //각 뷰들을 넣을 스크롤뷰 생성
        let ScrollView = UIScrollView()
        ScrollView.backgroundColor = .white
        ScrollView.isScrollEnabled = true
        ScrollView.showsHorizontalScrollIndicator = true
        //스택뷰를 이용해 오토레이아웃 설정
        let StackView = UIStackView()
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
        let ImageView = UIImageView()
        print("post.image가 nil인가? : \(post.image)")
        if(post.image == nil) {
            print("post.image가 nil인데 화면의 크기의 조정이 필요합니다.")
        }else{
            ImageView.image = post.image
            ImageView.contentMode = .scaleAspectFit
            ImageView.backgroundColor = .white
            DetailView.addSubview(ImageView)
            //Snapkit을 이용한 오토레이아웃
            ImageView.snp.makeConstraints{ (make) in
                make.top.equalTo(DetailLabel.snp.bottom).offset(10)
                make.trailing.equalToSuperview().offset(-40)
                make.leading.equalToSuperview().offset(30)
                make.height.equalTo(200)
            }
        }
        //게시물의 댓글을 나열 할 뷰
        let CommentTableView = UITableView()
        CommentTableView.backgroundColor = .white
        CommentTableView.delegate = self
        CommentTableView.dataSource = self
        CommentTableView.frame = view.bounds
        CommentTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        CommentTableView.showsHorizontalScrollIndicator = false
        CommentTableView.isScrollEnabled = false
        CommentTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 0.2
        
        //댓글 입력 창과 버튼을 추가
        let commentField = ExpandingTextView()
        commentField.backgroundColor =  #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        commentField.layer.cornerRadius = 10
        commentField.layer.masksToBounds = true
        commentField.font = UIFont.boldSystemFont(ofSize: 17)
        //Snapkit을 이용한 오토레이아웃
        view.addSubview(commentField)
        commentField.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(self.view.frame.width / 1.4)
            make.height.greaterThanOrEqualTo(self.view.frame.height / 20) // 최소 높이
            make.height.lessThanOrEqualTo(self.view.frame.height / 11) // 최대 높이
        }
        let CommentBtn = UIButton()
        CommentBtn.backgroundColor =  #colorLiteral(red: 0.9744978547, green: 0.7001121044, blue: 0.6978833079, alpha: 1)
        CommentBtn.layer.cornerRadius = 10
        CommentBtn.layer.masksToBounds = true
        let iconImage = UIImage(systemName: "message")
        CommentBtn.setImage(iconImage, for: .normal)
        CommentBtn.tintColor = .black
        view.addSubview(CommentBtn)
        //SnapKit을 이용한 오토레이아웃 설정
        CommentBtn.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
            make.width.equalTo(self.view.frame.width / 5)
            make.height.equalTo(self.view.frame.height / 20)
        }
        
        StackView.addArrangedSubview(DetailView)
        StackView.addArrangedSubview(CommentTableView)
        ScrollView.addSubview(StackView)
        self.view.addSubview(ScrollView)
        self.view.addSubview(view)
        view.snp.makeConstraints{ (make) in
            make.height.equalTo(self.view.frame.height / 7.5)
            make.leading.trailing.equalToSuperview().inset(0)
            make.bottom.equalToSuperview()
        }
        //SnapKit을 이용한 오토레이아웃 설정
        ScrollView.snp.makeConstraints{ (make) in
            make.bottom.equalToSuperview().offset(-self.view.frame.height / 8.5)
            make.top.equalToSuperview().offset(self.view.frame.height / 8.5)
            make.trailing.leading.equalToSuperview().inset(0)
        }
        StackView.snp.makeConstraints{ (make) in
//            make.height.equalTo(CommentTableView.frame.height)
            if(post.image == nil){
                print("post.image가 nil이기 때문에 크기가 조정됩니다.")
                make.height.equalTo(DetailLabel.frame.height + CGFloat((comments.count + 2) * 100))
            }else{
                make.height.equalTo(DetailLabel.frame.height + ImageView.frame.height + CGFloat((comments.count + 4) * 100))
            }
            make.width.equalTo(ScrollView.snp.width)
            make.bottom.equalToSuperview().offset(-0)
            make.top.equalToSuperview().offset(0)
        }
        DetailView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(20)
            if(post.image == nil){
                print("post.image가 nil이기 때문에 크기가 조정됩니다.")
                make.height.equalTo(DetailLabel.frame.height + 100)
            }else{
                make.height.equalTo(DetailLabel.frame.height + ImageView.frame.height + 300)
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
        }
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        adjustCommentView(insets: contentInsets)
    }

    private func adjustCommentView(insets: UIEdgeInsets) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.view.frame.origin.y = -insets.bottom
        }
    }

    @objc func toolBtnTapped() {
        let alertController = UIAlertController(title: "댓글 메뉴", message: nil, preferredStyle: .alert)
        getAuthorInfo() // 게시글 작성자 정보를 가져옴
        getCurrentUserInfo() // 게시글 사용자 정보를 가져옴
        let isMyPost = checkIfCurrentIsAuthorOfPost(userIdOfAuthor: userIdOfAuthor, currentUserId: currentUserId) //게시글의 작성자와 현재 사용자가 동일한지 판별
        
        //게시글의 작성자와 현재 사용자가 같을때
        if isMyPost {
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
            let DeclarationController = UIAlertAction(title: "신고", style: .default) { (_) in
                
            }
            alertController.addAction(DeclarationController)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        let comment = comments[indexPath.row]
        cell.commentLabel.text = comment.comment
        return cell
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    //댓글을 눌렀을때 신고하기 팝업
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alertController = UIAlertController(title: "댓글 메뉴", message: nil, preferredStyle: .alert)
        getAuthorInfo() // 게시글 작성자 정보를 가져옴
        getCurrentUserInfo() // 게시글 사용자 정보를 가져옴
        let isMyPost = checkIfCurrentIsAuthorOfPost(userIdOfAuthor: userIdOfAuthor, currentUserId: currentUserId) //게시글의 작성자와 현재 사용자가 동일한지 판별
        
        //게시글의 작성자와 현재 사용자가 같을때
        if isMyPost {
                    // 삭제
            let deleteAction = UIAlertAction(title: "삭제", style: .default) { (_) in
                self.CommentDelete()
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
                
            }
            alertController.addAction(DeclarationController)
        }
        //취소
        let CancelController = UIAlertAction(title: "취소", style: .default) { (_) in
            
        }
        alertController.addAction(CancelController)
        present(alertController, animated: true)
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
    //게시물 작성자와 현재 사용자를 비교하는 함수
    func checkIfCurrentIsAuthorOfPost(userIdOfAuthor: String, currentUserId: String) -> Bool {
        print("checkIfCurrentIsAutorOfPost - called()")
        //게시물 작성자와 현재 작성자를 판별
        return userIdOfAuthor == currentUserId // 현재는 내 게시물로 가정 true 반환
    }
    //현재 게시물의 작성자, 사용자를 가져오는 메서드
    // 현재 사용자 정보를 가져오는 메서드
    func getCurrentUserInfo() {
        print("getCurrentUserInfo - called()")
        
        // 현재 사용자의 사용자 ID 또는 다른 식별자를 사용하여 API 호출
        let currentUserId = "현재 사용자의 사용자 ID" // 실제 사용자 ID 또는 식별자로 대체해야 합니다.
        
        guard let url = URL(string: "https://yourapi.com/userInfo/\(currentUserId)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // 인증 헤더 또는 토큰을 추가!!
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let data = data {
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    self.currentUserId = user.userId
                    // 여기서 현재 사용자 정보를 필요한 속성에 저장하거나 처리할 수 있습니다.
                } catch {
                    print("Error decoding current user data: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
    // 게시물의 작성자 정보를 가져오는 메서드
    func getAuthorInfo() {
        print("getAuthorInfo - called()")
        
        
        guard let url = URL(string: "https://yourapi.com/userInfo/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // 인증 헤더 또는 토큰을 추가!!
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            if let data = data {
                do {
                    let user = try JSONDecoder().decode(User.self, from: data)
                    self.userIdOfAuthor = user.userId
                    // 게시물 작성자 정보를 필요한 속성에 저장, 처리 가능
                } catch {
                    print("Error decoding author data: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }

    //게시글 삭제 메서드
    func PostDelete() {
        print("PostDelete - called()")
        if checkIfCurrentIsAuthorOfPost(userIdOfAuthor: userIdOfAuthor, currentUserId: currentUserId) {
            // 지금 임시로 삭제 팝업창 띄우기 > 수정 필요
            let DeleteAlertController = UIAlertController(title: nil, message: "게시글이 삭제 되었습니다.", preferredStyle: .alert)
            let CancelController = UIAlertAction(title: "확인", style: .default) { (_) in
                // OpenBoardViewController로 이동
                if let openboardViewController = self.navigationController?.viewControllers.first(where: { $0 is OpenBoardViewController }) {
                    self.navigationController?.popToViewController(openboardViewController, animated: true)
                }
            }
            DeleteAlertController.addAction(CancelController)
            self.present(DeleteAlertController, animated: true)
            // 서버에 삭제 요청을 보내는 예시
            guard let url = URL(string: "https://yourapi.com/deletePost/") else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            // 인증 헤더 또는 토큰을 추가

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                // 삭제가 성공하면 화면에서 업데이트 필요 >> OpenBoard로 이동해서 새로운 창 로딩 필요 >> 새로고침 필요
//                let DeleteAlertController = UIAlertController(title: nil, message: "게시글이 삭제 되었습니다.", preferredStyle: .alert)
//                let CancelController = UIAlertAction(title: "확인", style: .default) { (_) in
//                    // OpenBoardViewController로 이동
//                    if let openboardViewController = self.navigationController?.viewControllers.first(where: { $0 is OpenBoardViewController }) {
//                        self.navigationController?.popToViewController(openboardViewController, animated: true)
//                    }
//                }
//                DeleteAlertController.addAction(CancelController)
//                self.present(DeleteAlertController, animated: true)
            }
            task.resume()
        } else {
            // 게시글 작성자가 아닌 경우 삭제 권한이 없음을 사용자에게 알릴기 >> 애초에 팝업창이 다르게 뜨도록 설정
        }
    }
    //댓글 삭제 메서드
    func CommentDelete() {
        print("CommentDelete - called()")
        if checkIfCurrentIsAuthorOfPost(userIdOfAuthor: userIdOfAuthor, currentUserId: currentUserId) {
            // 지금 임시로 삭제 팝업창 띄우기 > 수정 필요
            let DeleteAlertController = UIAlertController(title: nil, message: "댓글이 삭제 되었습니다.", preferredStyle: .alert)
            let CancelController = UIAlertAction(title: "확인", style: .default) { (_) in
                //해당 게시글 페이지 재로드
            }
            DeleteAlertController.addAction(CancelController)
            self.present(DeleteAlertController, animated: true)
            // 서버에 삭제 요청을 보내는 예시
            guard let url = URL(string: "https://yourapi.com/deletePost/") else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            // 인증 헤더 또는 토큰을 추가

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                // 삭제가 성공하면 화면에서 업데이트 필요 >> OpenBoard로 이동해서 새로운 창 로딩 필요 >> 새로고침 필요
//                let DeleteAlertController = UIAlertController(title: nil, message: "게시글이 삭제 되었습니다.", preferredStyle: .alert)
//                let CancelController = UIAlertAction(title: "확인", style: .default) { (_) in
//                    // OpenBoardViewController로 이동
//                }
//                DeleteAlertController.addAction(CancelController)
//                self.present(DeleteAlertController, animated: true)
            }
            task.resume()
        } else {
            // 게시글 작성자가 아닌 경우 삭제 권한이 없음을 사용자에게 알릴기 >> 애초에 팝업창이 다르게 뜨도록 설정
        }
    }
}
