//
//  PostDetailViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/07/30.
//

import Foundation
import UIKit
//댓글 창
struct Coment {
    let coment : String
}
//게시물의 상세 내용을 보여주는 UIViewController
class PostDetailViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView = UITableView()
    // 댓글을 저장할 배열
    var comments: [String] = []
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
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.showsVerticalScrollIndicator = false
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints{(make) in
            make.top.equalToSuperview().offset(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(0)
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 200
        } else if section == 1{
            return 450
        }
//        else if section == 2{
//            return 600
//        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            //게시물의 상세 페이지를 보여주는 뷰
            let headerView = UIView()
            headerView.backgroundColor = .white

            let label = UILabel()
            label.text = post.content
            label.numberOfLines = 0
            label.textAlignment = .center
            headerView.addSubview(label)
            label.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(50)
            make.bottom.equalToSuperview().offset(-100) // 높이를 설정해줌
            }
            return headerView
        } else if section == 1{
            //댓글 창을 만들 뷰
//            let CommenttableView = UITableView(frame: .zero, style: .grouped)
//            CommenttableView.delegate = self
//            CommenttableView.dataSource = self
//            CommenttableView.backgroundColor = .white
//            CommenttableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
//            CommenttableView.frame = view.bounds
//
//            return CommenttableView
            return nil
        }
//        else if section == 2{
//            //댓글을 입력하는 뷰
//            let CommentWriteView = UIView()
//            CommentWriteView.backgroundColor =  #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
//            //댓글 입력 텍스트필드
//            let CommentWriteText = UITextField()
//            let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10)) // 원하는 크기로 설정
//            CommentWriteText.rightView = spaceView
//            CommentWriteText.rightViewMode = .always // 항상 표시되도록 설정
//            CommentWriteText.textAlignment = .right
//            CommentWriteText.backgroundColor = .white
//            CommentWriteText.layer.cornerRadius = 20
//            CommentWriteText.layer.masksToBounds = true
//            CommentWriteView.addSubview(CommentWriteText)
//            //댓글 입력 버튼
//            let CommentWriteBtn = UIButton(type: .system)
//            CommentWriteBtn.backgroundColor = .white
//            let iconImage = UIImage(systemName: "message")
//            CommentWriteBtn.setImage(iconImage, for: .normal)
//            CommentWriteView.addSubview(CommentWriteBtn)
//
//            //SnapKit을 이용해 오토레이아웃 설정
//            CommentWriteText.snp.makeConstraints{ (make) in
//                make.top.equalToSuperview().offset(10)
//                make.bottom.equalToSuperview().offset(10)
//                make.leading.equalToSuperview().offset(10)
//                make.width.equalTo(200)
//            }
//            CommentWriteBtn.snp.makeConstraints{ (make) in
//                make.top.equalToSuperview().offset(10)
//                make.top.equalToSuperview().offset(10)
//                make.leading.equalTo(CommentWriteText.snp.trailing).offset(10)
//            }
//            CommentWriteView.snp.makeConstraints{ (make) in
//                make.bottom.equalToSuperview().offset(0)
//                make.leading.trailing.equalToSuperview().inset(0)
//            }
//            return CommentWriteView
//            return nil
//        }
        return nil
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

