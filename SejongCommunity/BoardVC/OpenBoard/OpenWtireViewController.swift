//
//  OpenWtireViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/07/30.
//

import Foundation
import UIKit
import SnapKit

class OpenWriteViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    let tableView = UITableView()
    //게시판 제목과 글, 그림을 등록하기 위한 뷰
    let OpenWriteView : UIView = {
        let view = UIView()
        //게시물의 제목
        let Title = UITextField(frame: CGRect(x: 10, y: 90, width: 350, height: 50))
        Title.textAlignment = .left
        Title.placeholder = "  Title"
        Title.font = UIFont.boldSystemFont(ofSize: 20)
//        Title.borderStyle = .roundedRect
        Title.layer.borderWidth = 0.6
        Title.layer.cornerRadius = 10
        Title.layer.masksToBounds = true
        view.addSubview(Title)
        
        //게시물의 본문
        let Message = UITextView(frame: CGRect(x: 10, y: 170, width: 350, height: 300))
        Message.textAlignment = .left
        //Message.placeholder = "Message"
//        Message.borderStyle = .roundedRect
        
        Message.font = UIFont.boldSystemFont(ofSize: 15)
        Message.layer.borderWidth = 0.6
        Message.layer.cornerRadius = 10
        Message.layer.masksToBounds = true
        view.addSubview(Message)
        
        //게시물의 사진 업로드
        let UploadImage = UIButton(frame: CGRect(x: 10, y: 490, width: 350, height:60))
        UploadImage.backgroundColor = #colorLiteral(red: 1, green: 0.869592011, blue: 0.9207738042, alpha: 1)
        UploadImage.setTitle("Upload Image", for: .normal)
        UploadImage.setTitleColor(.black, for: .normal)
        UploadImage.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        UploadImage.titleLabel?.textAlignment = .left
        UploadImage.layer.cornerRadius = 10
        UploadImage.layer.masksToBounds = true
        view.addSubview(UploadImage)
        let UploadBtn = UIButton(frame: CGRect(x: 40, y: 580, width: 300, height:60))
        UploadBtn.backgroundColor =  #colorLiteral(red: 0.9744978547, green: 0.7001121044, blue: 0.6978833079, alpha: 1)
        UploadBtn.setTitle("업로드", for: .normal)
        UploadBtn.setTitleColor(.black, for: .normal)
        UploadBtn.layer.cornerRadius = 30
        UploadBtn.layer.masksToBounds = true
        view.addSubview(UploadBtn)
        return view
    }()
    override func viewDidLoad(){
        self.view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .red
        self.view.addSubview(OpenWriteView)
        OpenWriteView.snp.makeConstraints{ (make) in
            make.edges.equalToSuperview()
                .inset(UIEdgeInsets(top: 100, left: 10, bottom: 20, right: 10))
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func showPostDetail() {
        
    }
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
}
