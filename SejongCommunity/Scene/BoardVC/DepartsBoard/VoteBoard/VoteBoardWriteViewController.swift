//
//  VoteBoardWriteViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/08/30.
//

import Foundation
import UIKit
import SnapKit
class VoteBoardWriteViewController : UIViewController {
    var tableView = UITableView()
    //익명 표시
    let anonymousView : UIView = {
        let view = UIView()
        let ccLabel = UIView()
        ccLabel.backgroundColor = #colorLiteral(red: 0.9744978547, green: 0.7001121044, blue: 0.6978833079, alpha: 1)
        ccLabel.layer.cornerRadius = 10
        let StudentLabel = UILabel()
        StudentLabel.text = "익명"
        StudentLabel.textColor = .black
        StudentLabel.font = UIFont.boldSystemFont(ofSize: 20)
        
        //StackView를 이용해 오토레이아웃 설정
        let StackView = UIStackView()
        StackView.axis = .horizontal
        StackView.spacing = 20
        StackView.distribution = .fill
        StackView.alignment = .fill
        StackView.backgroundColor = .white
        StackView.addArrangedSubview(ccLabel)
        StackView.addArrangedSubview(StudentLabel)
        view.addSubview(StackView)
        
        //Snapkit을 이용해 오토레이아웃 설정
        StackView.snp.makeConstraints{ (make) in
            make.bottom.leading.trailing.equalToSuperview().inset(0)
            make.top.equalToSuperview().offset(27)
        }
        ccLabel.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(0)
            make.width.equalTo(StackView.snp.width).dividedBy(9.5)
        }
        StudentLabel.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(0)
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
        
        //StackView를 이용해 오토레이아웃 설정
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.spacing = 20
        StackView.distribution = .fill
        StackView.alignment = .fill
        StackView.backgroundColor = .white
        StackView.addArrangedSubview(Title)
        StackView.addArrangedSubview(Message)
        StackView.addArrangedSubview(UploadImage)
        StackView.addArrangedSubview(UploadBtn)
        view.addSubview(StackView)
        
        //SnapKit을 이용한 오토레이아웃 설정
        StackView.snp.makeConstraints{ (make) in
            make.top.bottom.leading.trailing.equalToSuperview().inset(0)
        }
        Title.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(0)
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
       
        let ScrollView = UIScrollView()
        ScrollView.backgroundColor = .white
        ScrollView.isScrollEnabled = true
        ScrollView.showsHorizontalScrollIndicator = false
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.spacing = 20
        StackView.distribution = .fill
        StackView.alignment = .fill
        StackView.backgroundColor = .white
        StackView.addArrangedSubview(anonymousView)
        StackView.addArrangedSubview(OpenWriteView)
        ScrollView.addSubview(StackView)
        self.view.addSubview(ScrollView)
        
        //Snapkit을 이용해 오토레이아웃 설정
        ScrollView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(self.view.frame.height / 8.5)
            make.bottom.equalToSuperview().offset(-self.view.frame.height / 8.5)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        StackView.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(ScrollView.snp.height)
            make.width.equalTo(ScrollView.snp.width)
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-3)
        }
        anonymousView.snp.makeConstraints{ (make) in
//            make.top.equalToSuperview().offset(50)
            make.height.equalTo(StackView.snp.height).dividedBy(10)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        OpenWriteView.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().offset(0)
            make.top.equalTo(anonymousView.snp.bottom).offset(20)
        }
        setupTapGesture()
    }
    //화면의 다른 곳을 눌렀을 때 가상키보드가 사라짐
    func setupTapGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            self.view.addGestureRecognizer(tapGesture)
    }
    @objc func handleTap() {
        self.view.endEditing(true) // 키보드가 열려있을 경우 닫기
    }
    //이미지 업로드 메서드
    @objc func UploadImageBtnTapped(){
        
    }
}
