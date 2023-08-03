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
    var tableView = UITableView()
    //익명 표시
    let anonymousView : UIView = {
        let view = UIView()
        let ccLabel = UIView()
        ccLabel.backgroundColor = #colorLiteral(red: 0.9744978547, green: 0.7001121044, blue: 0.6978833079, alpha: 1)
        ccLabel.layer.cornerRadius = 20
        view.addSubview(ccLabel)
        let StudentLabel = UILabel()
        StudentLabel.text = "익명"
        StudentLabel.textColor = .black
        StudentLabel.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(StudentLabel)
        
        //Snapkit을 이용해 오토레이아웃 설정
        ccLabel.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(45)
            make.leading.equalToSuperview().offset(0)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        StudentLabel.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset((60))
            make.leading.equalTo(ccLabel.snp.trailing).offset(20)
        }
        return view
    }()
    //게시판 제목과 글, 그림을 등록하기 위한 뷰
    let OpenWriteView : UIView = {
        let view = UIView()
        //게시물의 제목
        let Title = UITextField()
        Title.textAlignment = .left
        Title.placeholder = "Title"
        Title.font = UIFont.boldSystemFont(ofSize: 20)
//        Title.borderStyle = .roundedRect
        Title.layer.borderWidth = 0.6
        Title.layer.cornerRadius = 10
        Title.layer.masksToBounds = true
        let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10)) // 원하는 크기로 설정
        Title.leftView = spaceView
        Title.leftViewMode = .always // 항상 표시되도록 설정
        view.addSubview(Title)
        
        //게시물의 본문
        let Message = UITextView()
        Message.textAlignment = .left
        Message.font = UIFont.boldSystemFont(ofSize: 15)
        Message.layer.borderWidth = 0.6
        Message.layer.cornerRadius = 10
        Message.layer.masksToBounds = true
        view.addSubview(Message)
        
        //게시물의 사진 업로드
        let UploadImage = UIButton()
        UploadImage.backgroundColor = #colorLiteral(red: 1, green: 0.869592011, blue: 0.9207738042, alpha: 1)
        //.action 아이콘 추가
        let iconImage = UIImage(systemName: "square.and.arrow.up")
        UploadImage.setTitle("\tUpload Image\t\t\t\t\t\t\t", for: .normal)
        UploadImage.setTitleColor(.black, for: .normal)
        UploadImage.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        UploadImage.contentHorizontalAlignment = .left
        UploadImage.layer.cornerRadius = 10
        UploadImage.layer.masksToBounds = true
        UploadImage.tintColor = .black
        UploadImage.setImage(iconImage, for: .normal)
        UploadImage.semanticContentAttribute = .forceRightToLeft
        view.addSubview(UploadImage)
        
        let UploadBtn = UIButton()
        UploadBtn.backgroundColor =  #colorLiteral(red: 0.9744978547, green: 0.7001121044, blue: 0.6978833079, alpha: 1)
        UploadBtn.setTitle("업로드", for: .normal)
        UploadBtn.setTitleColor(.black, for: .normal)
        UploadBtn.layer.cornerRadius = 20
        UploadBtn.layer.masksToBounds = true
        view.addSubview(UploadBtn)
        
        //SnapKit을 이용한 오토레이아웃 설정
        Title.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(30)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(60)
        }
        Message.snp.makeConstraints{(make) in
            make.top.equalTo(Title.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(250)
        }
        UploadImage.snp.makeConstraints{ (make) in
            make.top.equalTo(Message.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(60)
        }
        UploadBtn.snp.makeConstraints{(make) in
            make.top.equalTo(UploadImage.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }
        return view
    }()
    override func viewDidLoad(){
        self.view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .red
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(0)
        }
        
    }
    //이미지 업로드 메서드
    @objc func UploadImageBtnTapped(){
        
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
            return 100
        } else if section == 1{
            return 490
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return anonymousView
        } else if section == 1{
            return OpenWriteView
        }
        return nil
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
