//
//  OpenWtireViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/07/30.
//

import Foundation
import UIKit
import SnapKit

class OpenWriteViewController : UIViewController, UITextViewDelegate {
    var tableView = UITableView()
    //Textview의 placeholder
    let placeholderText = "내용"
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
    // 전역 변수로 선언
    var titleTextField: UITextField?
    var messageTextView: UITextView?
    override func viewDidLoad(){
        self.view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .red
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black] 
        //게시판 제목과 글, 그림을 등록하기 위한 뷰
        let OpenWriteView = UIView()
        let WriteStackView = UIStackView()
        WriteStackView.axis = .vertical
        WriteStackView.spacing = 20
        WriteStackView.distribution = .fill
        WriteStackView.alignment = .fill
        WriteStackView.backgroundColor = .white
        var Title = UITextField()
        Title.borderStyle = .none
        Title.layer.backgroundColor = UIColor.white.cgColor
        Title.textAlignment = .left
        Title.placeholder = "제목"
        Title.font = UIFont.boldSystemFont(ofSize: 20)
        Title.layer.cornerRadius = 10
        Title.layer.masksToBounds = true
        let spaceView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10)) // 원하는 크기로 설정
        Title.leftView = spaceView
        Title.leftViewMode = .always // 항상 표시되도록 설정
        //게시물의 본문
        var Message = UITextView()
        Message.textAlignment = .left
        Message.text = placeholderText
        Message.delegate = self
        Message.textColor = UIColor.lightGray
        Message.font = UIFont.boldSystemFont(ofSize: 15)
        Message.layer.cornerRadius = 10
        Message.layer.masksToBounds = true
        
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
        
        let UploadBtn = UIButton()
        UploadBtn.backgroundColor =  #colorLiteral(red: 0.9744978547, green: 0.7001121044, blue: 0.6978833079, alpha: 1)
        UploadBtn.setTitle("업로드", for: .normal)
        UploadBtn.setTitleColor(.black, for: .normal)
        UploadBtn.layer.cornerRadius = 20
        UploadBtn.layer.masksToBounds = true
        UploadBtn.addTarget(self, action: #selector(UploadBtnTapped), for: .touchUpInside)
        
        WriteStackView.addArrangedSubview(Title)
        let Spacing = UIView()
        Spacing.backgroundColor = .gray
        WriteStackView.addArrangedSubview(Spacing)
        WriteStackView.addArrangedSubview(Message)
        WriteStackView.addArrangedSubview(UploadImage)
        WriteStackView.addArrangedSubview(UploadBtn)
        OpenWriteView.addSubview(WriteStackView)
        //SnapKit을 이용한 오토레이아웃 설정
        WriteStackView.snp.makeConstraints{ (make) in
            make.top.bottom.leading.trailing.equalToSuperview().inset(0)
        }
        Title.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(0)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(60)
        }
        Spacing.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(0.5)
        }
        Message.snp.makeConstraints{(make) in
            make.top.equalTo(Spacing.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
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
        self.titleTextField = Title
        self.messageTextView = Message
        
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
    // UITextView Delegate 메서드
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholderText
            textView.textColor = UIColor.lightGray
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
    //업로드 메서드
    @objc func UploadBtnTapped(){
        // 전송할 데이터 (텍스트 뷰와 필드의 내용)
        let titleText = titleTextField?.text ?? ""
        let messageText = messageTextView?.text ?? ""
                
        print("UploadBtnTapped() - \(titleText), \(messageText)")
        if(titleText == ""){
            if(messageText == ""){
                //둘다 없을때
                let alertController = UIAlertController(title: nil, message: "제목과 내용을 작성해 주세요.", preferredStyle: .alert)
                let CancelController = UIAlertAction(title: "확인", style: .default) { (_) in
                }
                alertController.addAction(CancelController)
                present(alertController, animated: true)
            }
            //게시글의 제목이 없을때 팝업
            else{let alertController = UIAlertController(title: nil, message: "제목을 작성해 주세요.", preferredStyle: .alert)
                let CancelController = UIAlertAction(title: "확인", style: .default) { (_) in
                }
                alertController.addAction(CancelController)
                present(alertController, animated: true)}
        }else if(messageText == ""){
            //게시글의 내용이 없을때 팝업
            let alertController = UIAlertController(title: nil, message: "내용을 작성해 주세요.", preferredStyle: .alert)
            let CancelController = UIAlertAction(title: "확인", style: .default) { (_) in
            }
            alertController.addAction(CancelController)
            present(alertController, animated: true)
        }else{
            //MARK: JSON 통신
            let apiURLString = "https://example.com/api/upload"
            var request = URLRequest(url: URL(string: apiURLString)!)
            request.httpMethod = "POST"
            //적절할때 통신
            let requestBody: [String: Any] = [
                "title": titleText,
                "message": messageText
            ]
            // JSON 데이터를 HTTP 요청 바디에 설정
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: []){
                request.httpBody = jsonData
            }
            // HTTP 요성 헤더 설정(필요에 따라 추가)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // URLSession을 사용하여 서버와 통신
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        // 서버 응답 처리
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let data = data {
                // 서버 응답 데이터 처리 (만약 필요하다면)
                if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // 서버로부터 받은 JSON 데이터 처리
                    print("Response JSON: \(responseJSON)")
                    }
                }
            }
            task.resume() // 요청 보내기
            
            //적절할때 업로드 완료 팝업
            let alertController = UIAlertController(title: nil, message: "게시글이 업로드 되었습니다.", preferredStyle: .alert)
            let CancelController = UIAlertAction(title: "확인", style: .default) { (_) in
                // OpenBoardViewController로 이동
                if let openboardViewController = self.navigationController?.viewControllers.first(where: { $0 is OpenBoardViewController }) {
                    self.navigationController?.popToViewController(openboardViewController, animated: true)
                }
            }
            alertController.addAction(CancelController)
            present(alertController, animated: true)
        }
    }
}
