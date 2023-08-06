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
//게시물의 상세 내용을 보여주는 UIViewController
class PostDetailViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var CommentTableView = UITableView()
    //게시물의 댓글을 작성할 새로운 탭바 생성
    let customTabBar = CustomTabBarController()
    // 댓글을 저장할 배열
    let comments : [Comment] = [
        Comment(comment: "첫 번째 댓글입니다"),
        Comment(comment: "두 번째 댓글입니다"),
        Comment(comment: "세 번째 댓글입니다"),
        Comment(comment: "네 번째 댓글입니다")
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
        let toolBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(toolBtnTapped))
        navigationItem.rightBarButtonItem = toolBtn
        
        setupView()
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
        DetailLabel.font = UIFont.boldSystemFont(ofSize: 15)
        DetailView.addSubview(DetailLabel)
        DetailLabel.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(0)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        //게시물의 댓글을 나열 할 뷰
        let CommentTableView = UITableView()
        CommentTableView.backgroundColor = .white
        CommentTableView.delegate = self
        CommentTableView.dataSource = self
        CommentTableView.frame = view.bounds
        CommentTableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        CommentTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 0.2
        //댓글 입력 창과 버튼을 추가
        let commentField = UITextField()
        commentField.placeholder = "댓글을 입력하세요"
        commentField.backgroundColor =  #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        commentField.layer.cornerRadius = 10
        commentField.layer.masksToBounds = true
        let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10)) // 원하는 크기로 설정
        commentField.leftView = spaceView
        commentField.leftViewMode = .always // 항상 표시되도록 설정
        //Snapkit을 이용한 오토레이아웃
        view.addSubview(commentField)
        commentField.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(self.view.frame.width / 1.4)
            make.height.equalTo(self.view.frame.height / 18)
            
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
            make.height.equalTo(self.view.frame.height / 18)
        }
        
        StackView.addArrangedSubview(DetailView)
        StackView.addArrangedSubview(CommentTableView)
        ScrollView.addSubview(StackView)
        self.view.addSubview(ScrollView)
        
        //SnapKit을 이용한 오토레이아웃 설정
        ScrollView.snp.makeConstraints{ (make) in
            make.bottom.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(self.view.frame.height / 8.5)
            make.trailing.leading.equalToSuperview().inset(0)
        }
        StackView.snp.makeConstraints{ (make) in
            make.height.equalTo(ScrollView.snp.height)
            make.width.equalTo(ScrollView.snp.width)
            make.bottom.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(0)
        }
        DetailView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(StackView.snp.height).dividedBy(6)
            make.leading.equalToSuperview().offset(20)
        }
        CommentTableView.snp.makeConstraints{ (make) in
            make.top.equalTo(DetailView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        self.view.addSubview(view)
        view.snp.makeConstraints{ (make) in
            make.height.equalTo(self.view.frame.height / 9)
            make.leading.trailing.equalToSuperview().inset(0)
            make.bottom.equalToSuperview()
        }
    }
    @objc func toolBtnTapped() {
        let alertController = UIAlertController(title: "글 메뉴", message: nil, preferredStyle: .alert)
        //메뉴 추가
        //쪽지 보내기
        let SendMessageController = UIAlertAction(title: "쪽지 보내기", style: .default) { (_) in
            // '쪽지' 버튼을 눌렀을 대의 동작을 구현
        }
        alertController.addAction(SendMessageController)
        //신고
        let DeclarationController = UIAlertAction(title: "신고", style: .default) { (_) in
            
        }
        alertController.addAction(DeclarationController)
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
    override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            //부모로 이동했을때 탭바를 다시 켬
            if isMovingFromParent {
                print("Back 버튼 클릭됨")
                tabBarController?.tabBar.isHidden = false
            }
        }
}

//댓글을 입력하는 새로운 탭바 생성
class CustomTabBarController : UITabBarController {
    override func viewDidLoad() {
        super .viewDidLoad()
        self.view.backgroundColor =  #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        setupView()
    }
    func setupView() {
        let view = UIView()
        //댓글 입력 창과 버튼을 추가
        let commentField = UITextField()
        commentField.placeholder = "댓글을 입력하세요"
        commentField.backgroundColor = .white
        //Snapkit을 이용한 오토레이아웃
        view.addSubview(commentField)
        commentField.snp.makeConstraints{ (make) in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.equalToSuperview().offset(0)
            make.width.equalTo(self.view.frame.width / 2.5)
        }
        let CommentBtn = UIButton()
        CommentBtn.backgroundColor =  #colorLiteral(red: 0.9744978547, green: 0.7001121044, blue: 0.6978833079, alpha: 1)
        CommentBtn.layer.cornerRadius = 10
        CommentBtn.layer.masksToBounds = true
        let iconImage = UIImage(systemName: "square.and.arrow.up")
        CommentBtn.setImage(iconImage, for: .normal)
        view.addSubview(CommentBtn)
        //SnapKit을 이용한 오토레이아웃 설정
        CommentBtn.snp.makeConstraints{ (make) in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.equalTo(commentField.snp.trailing).offset(20)
            make.width.equalTo(self.view.frame.width / 4)
        }
        
        self.view.addSubview(view)
    }
}

