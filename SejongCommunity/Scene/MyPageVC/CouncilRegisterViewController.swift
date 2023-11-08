//
//  CouncilRegisterViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/07/29.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class CouncilRegisterViewController : UIViewController{
    //이 뷰의 타이틀과 학생회 신청에 대한 설명을 나타내는 뷰
    var codetext : UITextField?
    let ExplainView : UIView = {
       let view = UIView()
        let text = UITextView()
        text.textColor = #colorLiteral(red: 0.6369416118, green: 0.7151209116, blue: 0.818664968, alpha: 1)
        text.text = "학생회 신청을 위한 페이지 입니다.\n일반 학생은 신청시 확인 후 기각됩니다."
        text.textAlignment = .center
        text.isEditable = false
        text.font = UIFont.boldSystemFont(ofSize: 15)
        
        //StackView를 이용해 오토레이아웃 설정
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.spacing = 20
        StackView.distribution = .fill
        StackView.alignment = .fill
        StackView.backgroundColor = .white
        StackView.addArrangedSubview(text)
        view.addSubview(StackView)
        
        //Snapkit을 이용해 오토레이아웃 설정
        StackView.snp.makeConstraints{ (make) in
            make.top.bottom.leading.trailing.equalToSuperview().offset(0)
        }
        
        text.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        
        return view
    }()
    
    //메일 주소를 적어둘 뷰
    let MailView : UIView = {
       let view = UIView()
        let text = UITextView()
        text.textColor = #colorLiteral(red: 0.6696126461, green: 0.6785762906, blue: 0.6784186959, alpha: 1)
        text.backgroundColor = #colorLiteral(red: 0.9680508971, green: 0.9680508971, blue: 0.9680508971, alpha: 1)
        text.text = "\n학생회분들은\nbrian876373@gmail.com\n로 메일 전송\n\n확인 후 인증코드가 발송됩니다."
        text.textAlignment = .center
        text.isEditable = false
        text.font = UIFont.boldSystemFont(ofSize: 15)
        view.backgroundColor = #colorLiteral(red: 0.9680508971, green: 0.9680508971, blue: 0.9680508971, alpha: 1)
        //StackView를 이용해 오토레이아웃 설정
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.spacing = 20
        StackView.distribution = .fill
        StackView.alignment = .fill
        StackView.backgroundColor =  #colorLiteral(red: 0.9680508971, green: 0.9680508971, blue: 0.9680508971, alpha: 1)
        StackView.addArrangedSubview(text)
        StackView.layer.cornerRadius = 10
        StackView.layer.masksToBounds = true
        view.addSubview(StackView)
        
        //Snapkit을 이용해 오토레이아웃 설정
        StackView.snp.makeConstraints{ (make) in
            make.top.bottom.leading.trailing.equalToSuperview().offset(0)
        }
        text.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(0)
            make.top.equalToSuperview().offset(35)
        }
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .red
        title = "학생회 신청"
        let CodeView = UIView()
         CodeView.backgroundColor = .white
         //코드를 입력받기 위한 UITextField
         let CodeText = UITextField()
         CodeText.placeholder = "ex) X6T3"
         CodeText.textAlignment = .center
         CodeText.font = UIFont.boldSystemFont(ofSize: 30)
         CodeText.text = ""
         CodeText.borderStyle = .roundedRect
         codetext = CodeText
         
         //인증받기 버튼
         let CodeBtn = UIButton()
         CodeBtn.backgroundColor = #colorLiteral(red: 0.9744978547, green: 0.7001121044, blue: 0.6978833079, alpha: 1)
         CodeBtn.setTitle("인증받기", for: .normal)
         CodeBtn.setTitleColor(.black, for: .normal)
         CodeBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
         CodeBtn.layer.cornerRadius = 20
         CodeBtn.layer.masksToBounds = true
         CodeBtn.addTarget(self, action: #selector(CodeBtnTapped), for: .touchUpInside)
         //StackView로 오토레이아웃 설정
         let CodeStackView = UIStackView()
         CodeStackView.axis = .vertical
         CodeStackView.spacing = 20
         CodeStackView.distribution = .fill
         CodeStackView.alignment = .fill
         CodeStackView.backgroundColor = .white
         CodeStackView.addArrangedSubview(CodeText)
         CodeStackView.addArrangedSubview(CodeBtn)
         let Spacing = UIView()
         Spacing.backgroundColor = .white
         CodeStackView.addArrangedSubview(Spacing)
         CodeView.addSubview(CodeStackView)
         //SnapKit으로 오토레이아웃 설정
         CodeStackView.snp.makeConstraints{ (make) in
             make.top.bottom.leading.trailing.equalToSuperview().offset(0)
         }
         CodeText.snp.makeConstraints{ (make) in
             make.top.equalToSuperview().offset(80)
             make.leading.trailing.equalToSuperview().inset(0)
             make.height.equalTo(60)
         }
         CodeBtn.snp.makeConstraints{ (make) in
             make.top.equalTo(CodeText.snp.bottom).offset(30)
             make.leading.trailing.equalToSuperview().inset(40)
             make.height.equalTo(60)
         }
         Spacing.snp.makeConstraints{ (make) in
             make.top.equalTo(CodeBtn.snp.bottom).offset(1)
         }
         CodeView.layer.cornerRadius = 10
         CodeView.layer.masksToBounds = true
        
        let ScrollView = UIScrollView()
        ScrollView.isScrollEnabled = true
        ScrollView.showsHorizontalScrollIndicator = false
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.spacing = 20
        StackView.distribution = .fill
        StackView.alignment = .fill
        StackView.backgroundColor = .white
        StackView.addArrangedSubview(ExplainView)
        StackView.addArrangedSubview(MailView)
        StackView.addArrangedSubview(CodeView)
        ScrollView.addSubview(StackView)
        self.view.addSubview(ScrollView)
        
        //Snapkit을 이용한 오토레이아웃
        ScrollView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(self.view.frame.height / 8.5)
            make.bottom.equalToSuperview().offset(-self.view.frame.height /  8.5)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        StackView.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(ScrollView.snp.height)
            make.width.equalTo(ScrollView.snp.width)
            make.top.equalToSuperview().offset(0)
            make.bottom.equalToSuperview().offset(-3)
        }
        ExplainView.snp.makeConstraints{ (make) in
            make.height.equalTo(StackView.snp.height).dividedBy(5)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        MailView.snp.makeConstraints{ (make) in
            make.height.equalTo(StackView.snp.height).dividedBy(3)
            make.leading.trailing.equalToSuperview().offset(0)
            make.top.equalTo(ExplainView.snp.bottom).offset(20)
        }
        CodeView.snp.makeConstraints{ (make) in
            make.top.equalTo(MailView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(0)
        }
    }
    //인증받기 버튼 액션
    @objc func CodeBtnTapped() {
        print("CodeBtnTapped - called()")
        //인증 코드
        var msg = ""
        let code = codetext?.text ?? ""
        let urlString = "https://keep-ops.shop/api/v1/council/auth"
        guard let url = URL(string: urlString) else{
            return //유효하지 않은 URL 처리
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        let requestbody : [String:Any] = [
            "grantCode" : code
        ]
        if let jsonData = try?JSONSerialization.data(withJSONObject: requestbody, options: []){
            request.httpBody = jsonData
        }
        // 토큰 유효성 검사
        if AuthenticationManager.isTokenValid(){}else{}
        // HTTP 요성 헤더 설정(필요에 따라 추가)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let token = KeychainWrapper.standard.string(forKey: "AuthToken")
        request.setValue(token, forHTTPHeaderField: "accessToken")
        var status = 0
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    // 서버 응답 처리
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let data = data {
            // 서버 응답 데이터 처리 (만약 필요하다면)
            if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                // 서버로부터 받은 JSON 데이터 처리
//                print("Response JSON: \(responseJSON)")
                status = responseJSON["status"] as? Int ?? 0
                print("학생회 신청 결과 값 - \(responseJSON)")
                if let message = responseJSON["message"] as? String{
                    msg = message
                    }
                }
            }
            if status == 200 {
                //적절할때. 업로드 완료가 되었을때. 팝업. reload
                DispatchQueue.main.async{
                    self.codetext?.text = ""
                    let alertController = UIAlertController(title: "신청이 완료 되었습니다.", message: "승인 메일 수신 시 로그아웃", preferredStyle: .alert)
                    let CancelController = UIAlertAction(title: "확인", style: .default) { (_) in
                        // OpenBoardViewController로 이동
                        if let openboardViewController = self.navigationController?.viewControllers.first(where: { $0 is MypageViewController }) {
                            self.navigationController?.popToViewController(openboardViewController, animated: true)
                        }
                    }
                    alertController.addAction(CancelController)
                    self.present(alertController, animated: true)
                }
            }else if msg == "코드가 일치하지 않습니다."{
                DispatchQueue.main.async{
                    self.codetext?.text = ""
                    let alertController = UIAlertController(title: "코드가 일치하지 않습니다.", message: nil, preferredStyle: .alert)
                    let CancelController = UIAlertAction(title: "확인", style: .default) { (_) in
                        
                    }
                    alertController.addAction(CancelController)
                    self.present(alertController, animated: true)
                }
            }
        }
        task.resume() // 요청 보내기
    }
}
