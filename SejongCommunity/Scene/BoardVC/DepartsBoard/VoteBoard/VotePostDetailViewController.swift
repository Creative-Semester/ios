//
//  VotePostDetailViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/08/30.
//

import Foundation
import UIKit
struct VoteComment {
    let comment : String
}
struct VoteUser: Codable {
    let userId: String // 사용자 아이디에 맞는 속성을 추가
    // 다른 사용자 정보 속성들도 추가할 수 있습니다
}
class VotePostDetailViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    //현재 게시물의 작성자를 전역변수로 선언
    var userIdOfAuthor : String = ""
    //현재 로그인한 사용자의 사용자 ID
    var currentUserId : String = ""
    //투표기능 변수
    var agreeCount = 5
    var disagreeCount = 2
    //투표 중복 여부
    var isAgreed = false
    var isDisagreed = false
    //투표 버튼, 라벨, 비율
    let agreeButton = UIButton()
    let disagreeButton = UIButton()
    let agreeCountLabel = UILabel()
    let disagreeCountLabel = UILabel()
    let ratioLabel = UILabel()
    //투표 막대그래프
    let agreeProgressView = UIProgressView()
    let disagreeProgressView = UIProgressView()
    // 댓글 테이블
    var CommentTableView = UITableView()
    // 좋아요 버튼
    private let GreatBtn = UIButton()
    // 댓글을 저장할 배열
    let comments : [VoteComment] = [
        VoteComment(comment: "그건 아니죠,,"),
        VoteComment(comment: "아니 이걸?"),
        VoteComment(comment: "ㄹㅇㅋㅋ"),
        VoteComment(comment: "와우!! 핫게 가자"),
        VoteComment(comment: "와우!! 핫게 가자"),
        VoteComment(comment: "와우!! 핫게 가자"),
        VoteComment(comment: "와우!! 핫게 가자"),
        VoteComment(comment: "와우!! 핫게 가자"),
        VoteComment(comment: "와우!! 핫게 가자"),
        VoteComment(comment: "와우!! 핫게 가자"),
        VoteComment(comment: "와우!! 핫게 가자"),
        VoteComment(comment: "와우!! 핫게 가자"),
        VoteComment(comment: "끝")
    ]
    let post : VotePost
    //이니셜라이저를 사용하여 Post 객체를 전달받아 post 속성에 저장
    init(post: VotePost) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 댓글창 입력 전역변수
    var commentField = ExpandingTextView()
    var vview = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .red
        title = post.title
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
        updateRatioLabel()
        updateProgressViews()
        setupTapGesture()
    }
    func setupView(){
        //각 뷰들을 넣을 스크롤뷰 생성
        let ScrollView = UIScrollView()
        ScrollView.backgroundColor = .white
        ScrollView.isScrollEnabled = true
        ScrollView.showsHorizontalScrollIndicator = false
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
        
        //투표 구성
        // 찬성 버튼
        agreeButton.setTitle("찬성", for: .normal)
        agreeButton.setTitleColor(.darkGray, for: .normal)
        agreeButton.backgroundColor = isAgreed ? #colorLiteral(red: 0.5941179991, green: 1, blue: 0.670129776, alpha: 1) : #colorLiteral(red: 0.9472638965, green: 0.953559339, blue: 0.953448236, alpha: 1)
        agreeButton.layer.cornerRadius = 20
        agreeButton.layer.masksToBounds = true
        agreeButton.addTarget(self, action: #selector(agreeButtonTapped), for: .touchUpInside)
                
        // 반대 버튼
        disagreeButton.setTitle("반대", for: .normal)
        disagreeButton.setTitleColor(.darkGray, for: .normal)
        disagreeButton.backgroundColor = isDisagreed ? #colorLiteral(red: 1, green: 0.8256257772, blue: 0.8043001294, alpha: 1) : #colorLiteral(red: 0.9472638965, green: 0.953559339, blue: 0.953448236, alpha: 1)
        disagreeButton.layer.cornerRadius = 20
        disagreeButton.layer.masksToBounds = true
        disagreeButton.addTarget(self, action: #selector(disagreeButtonTapped), for: .touchUpInside)
                
        // 찬성 수 표시 라벨
        agreeCountLabel.text = "찬성: \(agreeCount)"
        agreeCountLabel.textColor = .black
                
        // 반대 수 표시 라벨
        disagreeCountLabel.text = "반대: \(disagreeCount)"
        disagreeCountLabel.textColor = .black
        // 비율 표시 라벨
        ratioLabel.textColor = .black
        
        //그래프 표시
        agreeProgressView.tintColor = #colorLiteral(red: 0.5941179991, green: 1, blue: 0.670129776, alpha: 1)
        disagreeProgressView.tintColor = #colorLiteral(red: 1, green: 0.8256257772, blue: 0.8043001294, alpha: 1)
        
        // 스택뷰를 이용한 레이아웃 설정
        let VoteView = UIView()
        VoteView.backgroundColor = .white
        VoteView.addSubview(agreeButton)
        VoteView.addSubview(agreeCountLabel)
        VoteView.addSubview(disagreeButton)
        VoteView.addSubview(disagreeCountLabel)
        VoteView.addSubview(ratioLabel)
        VoteView.addSubview(agreeProgressView)
        VoteView.addSubview(disagreeProgressView)
        //Snapkit 오토레이아웃 설정
        agreeButton.snp.makeConstraints{ (make) in
            make.width.equalTo(self.view.frame.width / 4)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(0)
        }
        agreeCountLabel.snp.makeConstraints{ (make) in
            make.width.equalTo(self.view.frame.width / 7)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(0)
            make.leading.equalTo(agreeButton.snp.trailing).offset(10)
        }
        disagreeCountLabel.snp.makeConstraints{ (make) in
            make.width.equalTo(self.view.frame.width / 7)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(-10)
        }
        disagreeButton.snp.makeConstraints{ (make) in
            make.width.equalTo(self.view.frame.width / 4)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(0)
            make.trailing.equalTo(disagreeCountLabel.snp.leading).offset(-10)
        }
        ratioLabel.snp.makeConstraints{(make) in
            make.top.equalTo(agreeButton.snp.bottom).offset(20)
        }
        agreeProgressView.snp.makeConstraints{(make) in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(ratioLabel.snp.bottom).offset(20)
            make.height.equalTo(30)
        }
        disagreeProgressView.snp.makeConstraints{(make) in
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(agreeProgressView.snp.bottom).offset(20)
            make.height.equalTo(30)
        }
        
        
        //게시물의 댓글을 나열 할 뷰
        let CommentTableView = UITableView()
        CommentTableView.backgroundColor = .white
        CommentTableView.delegate = self
        CommentTableView.dataSource = self
        CommentTableView.frame = view.bounds
        CommentTableView.isScrollEnabled = false
        CommentTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        CommentTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        StackView.addArrangedSubview(DetailView)
        StackView.addArrangedSubview(VoteView)
        StackView.addArrangedSubview(CommentTableView)
        ScrollView.addSubview(StackView)
        self.view.addSubview(ScrollView)
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
                make.height.equalTo(DetailLabel.frame.height + agreeButton.frame.height + CGFloat((comments.count + 4) * 100))
            }else{
                make.height.equalTo(DetailLabel.frame.height + agreeButton.frame.height + ImageView.frame.height + CGFloat((comments.count + 6) * 100))
            }
            make.width.equalTo(ScrollView.snp.width)
            make.bottom.equalToSuperview().offset(-0)
            make.top.equalToSuperview().offset(0)
        }
        DetailView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(20)
            if(post.image == nil){
                print("post.image가 nil이기 때문에 크기가 조정됩니다.")
                make.height.equalTo(DetailLabel.frame.height + agreeButton.frame.height + 100)
            }else{
                make.height.equalTo(DetailLabel.frame.height + agreeButton.frame.height + ImageView.frame.height + 300)
            }
            make.leading.equalToSuperview().offset(20)
        }
        VoteView.snp.makeConstraints{ (make) in
            make.top.equalTo(DetailView.snp.bottom).offset(20)
            if(post.image == nil){
                print("post.image가 nil이기 때문에 크기가 조정됩니다.")
                make.height.equalTo(disagreeButton.frame.height + agreeButton.frame.height + 200)
            }else{
                make.height.equalTo(disagreeButton.frame.height + agreeButton.frame.height + ImageView.frame.height + 400)
            }
            make.leading.equalToSuperview().offset(20)
        }
        CommentTableView.snp.makeConstraints{ (make) in
            make.top.equalTo(VoteView.snp.bottom).offset(0)
            make.leading.trailing.equalToSuperview().inset(0)
            make.bottom.equalToSuperview().offset(0)
        }
        // 댓글 입력 필드에 대한 Notification Observer 등록
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    //투표 비율
    func updateRatioLabel() {
        let totalVotes = agreeCount + disagreeCount
                if totalVotes > 0 {
                    let agreeRatio = Double(agreeCount) / Double(totalVotes) * 100
                    let disagreeRatio = Double(disagreeCount) / Double(totalVotes) * 100
                    ratioLabel.text = String(format: "찬성 비율: %.2f%% | 반대 비율: %.2f%%", agreeRatio, disagreeRatio)
                } else {
                    ratioLabel.text = "투표 없음"
                }
    }
    //투표 비율에 따른 그래프
    func updateProgressViews() {
        let totalVotes = agreeCount + disagreeCount
                if totalVotes > 0 {
                    let agreeRatio = Float(agreeCount) / Float(totalVotes)
                    let disagreeRatio = Float(disagreeCount) / Float(totalVotes)
                    agreeProgressView.progress = agreeRatio
                    disagreeProgressView.progress = disagreeRatio
                } else {
                    agreeProgressView.progress = 0
                    disagreeProgressView.progress = 0
                }
    }
    //찬성버튼을 눌렀을때 메서드
    @objc func agreeButtonTapped() {
            if !isAgreed {
                agreeCount += 1
                isAgreed = true
                agreeCountLabel.text = "찬성: \(agreeCount)"
                agreeButton.backgroundColor = #colorLiteral(red: 0.5941179991, green: 1, blue: 0.670129776, alpha: 1)
                agreeButton.isEnabled = false
                updateRatioLabel()
                updateProgressViews()
            }
        }
    //반대버튼을 눌렀을때 메서드
    @objc func disagreeButtonTapped() {
            if !isDisagreed {
                disagreeCount += 1
                isDisagreed = true
                
                disagreeCountLabel.text = "반대: \(disagreeCount)"
                disagreeButton.backgroundColor = #colorLiteral(red: 1, green: 0.8256257772, blue: 0.8043001294, alpha: 1)
                disagreeButton.isEnabled = false
                updateRatioLabel()
                updateProgressViews()
            }
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
//                vview.snp.makeConstraints{ (make) in
//                    make.height.equalTo(newSize.height + 30)
//                    make.leading.trailing.equalToSuperview().inset(0)
//                    make.bottom.equalToSuperview()
//                }
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
//                vview.snp.makeConstraints{ (make) in
//                    make.height.equalTo(newSize.height + 30)
//                    make.leading.trailing.equalToSuperview().inset(0)
//                    make.bottom.equalToSuperview()
//                }
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
//        vview.snp.makeConstraints{ (make) in
//            make.height.equalTo(self.view.frame.height / 9)
//            make.leading.trailing.equalToSuperview().inset(0)
//            make.bottom.equalToSuperview()
//        }
    }

    private func adjustCommentView(insets: UIEdgeInsets) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.view.frame.origin.y = -insets.bottom
        }
    }

    @objc func toolBtnTapped() {
        let alertController = UIAlertController(title: "댓글 메뉴", message: nil, preferredStyle: .alert)
        //게시글의 작성자와 현재 사용자가 같을때
        if true {
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
        //게시글의 작성자와 현재 사용자가 같을때
        if true {
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
            //부모로 이동해도 새로운 탭바를 사용할 것이기 때문에 기존의 탭바를 켤 필요 없음
//            if isMovingFromParent {
//                print("Back 버튼 클릭됨")
//                tabBarController?.tabBar.isHidden = false
//            }
        }
}
extension VotePostDetailViewController {
    //게시물 작성자와 현재 사용자를 비교하는 함수
    func checkIfCurrentIsAuthorOfPost(userIdOfAuthor: String, currentUserId: String) -> Bool {
        print("checkIfCurrentIsAutorOfPost - called()")
        //게시물 작성자와 현재 작성자를 판별
        return userIdOfAuthor == currentUserId // 현재는 내 게시물로 가정 true 반환
    }
    //게시글 삭제 메서드
    func PostDelete() {
        print("PostDelete - called()")
        if checkIfCurrentIsAuthorOfPost(userIdOfAuthor: userIdOfAuthor, currentUserId: currentUserId) {
            // 지금 임시로 삭제 팝업창 띄우기 > 수정 필요
            // 게시글 삭제 / 댓글 삭제 구분 필요
            let DeleteAlertController = UIAlertController(title: nil, message: "게시글이 삭제 되었습니다.", preferredStyle: .alert)
            let CancelController = UIAlertAction(title: "확인", style: .default) { (_) in
                // OpenBoardViewController로 이동
                if let openboardViewController = self.navigationController?.viewControllers.first(where: { $0 is VoteViewController }) {
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
