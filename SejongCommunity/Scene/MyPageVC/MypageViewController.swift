//
//  MypageViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/07/23.
//

import UIKit
import SnapKit
import SwiftKeychainWrapper
class MypageViewController: UIViewController{
    //학생의 정보(이름, 과)
    let Studenttitle = UILabel()
    let StudentInfo = UILabel()
    
    //각 버튼을 넣을 뷰 생성
    let BtnView : UIView = {
       let View = UIView()
        View.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        
        //내가 쓴 글을 보여줄 페이지로 이동할 버튼
        let MyWriteBtn = UIButton(type: .system)
        MyWriteBtn.backgroundColor = .white
        MyWriteBtn.setTitle("내가 쓴 글", for: .normal)
        MyWriteBtn.setTitleColor( #colorLiteral(red: 0.1660557687, green: 0.4608593583, blue: 0.6628261209, alpha: 1), for: .normal)
        MyWriteBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        MyWriteBtn.addTarget(self, action: #selector(MyWriteBtnTapped), for: .touchUpInside)
        MyWriteBtn.layer.cornerRadius = 30
        MyWriteBtn.layer.masksToBounds = true
        
        //내가 댓글 단 글을 보여줄 페이지로 이동할 버튼
        let MyComentBtn = UIButton()
        MyComentBtn.backgroundColor = .white
        MyComentBtn.setTitle("댓글 단 글", for: .normal)
        MyComentBtn.setTitleColor( #colorLiteral(red: 0.1660557687, green: 0.4608593583, blue: 0.6628261209, alpha: 1), for: .normal)
        MyComentBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        MyComentBtn.layer.cornerRadius = 30
        MyComentBtn.layer.masksToBounds = true
        MyComentBtn.addTarget(self, action: #selector(MyComentBtnTapped), for: .touchUpInside)
        
        //학생회 신청 페이지로 넘어갈 버튼
        let CouncilRegisterBtn = UIButton()
        CouncilRegisterBtn.backgroundColor = .white
        CouncilRegisterBtn.setTitle("학생회 신청", for: .normal)
        CouncilRegisterBtn.setTitleColor(#colorLiteral(red: 0.1660557687, green: 0.4608593583, blue: 0.6628261209, alpha: 1), for: .normal)
        CouncilRegisterBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        CouncilRegisterBtn.layer.cornerRadius = 30
        CouncilRegisterBtn.layer.masksToBounds = true
        CouncilRegisterBtn.addTarget(self, action: #selector(CouncilRegisterTapped), for: .touchUpInside)
        
        //로그아웃을 할 버튼 생성
        let LogoutBtn = UIButton()
        LogoutBtn.backgroundColor = .white
        LogoutBtn.setTitle("로그아웃", for: .normal)
        LogoutBtn.setTitleColor(#colorLiteral(red: 0.1660557687, green: 0.4608593583, blue: 0.6628261209, alpha: 1), for: .normal)
        LogoutBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        LogoutBtn.layer.cornerRadius = 30
        LogoutBtn.layer.masksToBounds = true
        LogoutBtn.addTarget(self, action: #selector(LogoutBtnTapped), for: .touchUpInside)
        
        let Spacing = UIView()
        Spacing.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        //StackView를 이용해 오토레이아웃 설정
        let StackView = UIStackView()
        StackView.alignment = .fill
        StackView.distribution = .fill
        StackView.axis = .vertical
        StackView.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        StackView.spacing = 30
        StackView.addArrangedSubview(MyWriteBtn)
        StackView.addArrangedSubview(MyComentBtn)
        StackView.addArrangedSubview(CouncilRegisterBtn)
        StackView.addArrangedSubview(LogoutBtn)
        StackView.addArrangedSubview(Spacing)
        View.addSubview(StackView)
        //SnapKit을 이용해 오토레이아웃
        StackView.snp.makeConstraints{ (make) in
            make.bottom.leading.trailing.equalToSuperview().inset(0)
            make.top.equalToSuperview().offset(40)
        }
        MyWriteBtn.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(0)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(70)
        }
        MyComentBtn.snp.makeConstraints{ (make) in
            make.top.equalTo(MyWriteBtn.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(70)
        }
        CouncilRegisterBtn.snp.makeConstraints{ (make) in
            make.top.equalTo(MyComentBtn.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(70)
        }
        LogoutBtn.snp.makeConstraints{ (make) in
            make.top.equalTo(CouncilRegisterBtn.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(70)
        }
        Spacing.snp.makeConstraints{ (make) in
            make.top.equalTo(LogoutBtn.snp.bottom).offset(1)
        }
        return View
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        SetStudentInfo()
        //StackView를 이용해 오토레이아웃 설정
        let ScrollView = UIScrollView()
        ScrollView.showsHorizontalScrollIndicator = false
        ScrollView.isScrollEnabled = true
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.distribution = .fill
        StackView.alignment = .fill
        StackView.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        StackView.spacing = 20
        //학생의 정보를 가져와 표시(이름, 과)
        let StudentLabelView = UIView()
        Studenttitle.font = UIFont.boldSystemFont(ofSize: 20)
        Studenttitle.textAlignment = .left
        Studenttitle.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        Studenttitle.textColor = #colorLiteral(red: 0.1660557687, green: 0.4608593583, blue: 0.6628261209, alpha: 1)
        StudentInfo.font = UIFont.boldSystemFont(ofSize: 15)
        StudentInfo.textAlignment = .left
        StudentInfo.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        StudentInfo.textColor = #colorLiteral(red: 0.1660557687, green: 0.4608593583, blue: 0.6628261209, alpha: 1)
        //학생의 이름과 과에 대한 정보를 가져올 메서드
        SetStudentInfo()
        
        //StackView를 이용한 오토레이아웃 설정
        let StudentStackView = UIStackView()
        StudentStackView.alignment = .fill
        StudentStackView.distribution = .fill
        StudentStackView.axis = .vertical
        StudentStackView.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        StudentStackView.spacing = 30
        StudentStackView.addArrangedSubview(Studenttitle)
        StudentStackView.addArrangedSubview(StudentInfo)
        StudentLabelView.addSubview(StudentStackView)
        
        //SnapKit을 이용한 오토레이아웃 설정
        StudentStackView.snp.makeConstraints{(make) in
            make.top.bottom.trailing.leading.equalToSuperview().inset(0)
        }
        Studenttitle.snp.makeConstraints{ (make) in
            make.leading.equalToSuperview().offset(0)
            make.top.equalToSuperview().offset(10)
        }
        StudentInfo.snp.makeConstraints{ (make) in
            make.top.equalTo(Studenttitle.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(0)
        }
        
        StackView.addArrangedSubview(StudentLabelView)
        StackView.addArrangedSubview(BtnView)
        ScrollView.addSubview(StackView)
        self.view.addSubview(ScrollView)
        
        //Snapkit을 이용한 오토레이아웃 설정
        ScrollView.snp.makeConstraints{ (make) in
            make.bottom.equalToSuperview().offset(-self.view.frame.height / 8.5)
            make.top.equalToSuperview().offset(self.view.frame.height / 8.5)
            make.trailing.leading.equalToSuperview().inset(50)
        }
        StackView.snp.makeConstraints{ (make) in
            make.height.equalTo(ScrollView.snp.height)
            make.width.equalTo(ScrollView.snp.width)
            make.bottom.equalToSuperview().offset(-3)
            make.top.equalToSuperview().offset(0)
        }
        StudentLabelView.snp.makeConstraints{ (make) in
            make.height.equalTo(StackView.snp.height).dividedBy(6)
        }
        BtnView.snp.makeConstraints{ (make) in
            make.top.equalTo(StudentLabelView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(0)
        }
    }
    //학생의 이름, 과 정보를 가져올 메서드
    func SetStudentInfo() {
        let urlString = "http://15.164.161.53:8082/api/v1/user/info"
        guard let url = URL(string: urlString)else{
            return //유효한 URL 인가?
        }
        var request = URLRequest(url: url)
        do{
            if AuthenticationManager.isTokenValid(){}else{} //토큰 유효성 검사
            let acToken = KeychainWrapper.standard.string(forKey: "AuthToken")
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(acToken, forHTTPHeaderField: "accessToken")
            // URLSession을 사용하여 요청 전송
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    // 에러 처리
                    print("Error: \(error.localizedDescription)")
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, (200...299)
                    .contains(httpResponse.statusCode)else{
                    // 서버 응답 상태 코드 처리
                    print("Invalid response status code - \(response)")
                    return
                }
                if let data = data {
                    do {
                        if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            print("Response: \(jsonResponse)")
                            // 서버로부터 받은 응답 데이터를 파싱하여 로그인 결과 처리
                            if let result = jsonResponse["result"] as? [String:Any],
                            let StudentTitle = result["name"] as? String,
                            let Studentinfo = result["majorName"] as? String{
                                DispatchQueue.main.async {
                                    self.Studenttitle.text = StudentTitle
                                    self.StudentInfo.text = Studentinfo
                                }
                            }
                        }else{
                            
                        }
                    }catch {
                        print("Error parsing response data: \(error.localizedDescription)")
                    }
                }
            }
            // URLSession 작업 시작
            task.resume()
        }catch {
            print("Error encoding parameters: \(error.localizedDescription)")
        }
    }
    //버튼 액션 처리 메서드
    @objc func MyWriteBtnTapped() {
        self.navigationController?.pushViewController(MyWriteViewController(), animated: true)
    }
    @objc func MyComentBtnTapped() {
        self.navigationController?.pushViewController(MyCommentViewController(), animated: true)
    }
    //학생회 신청 버튼 메서드
    @objc func CouncilRegisterTapped() {
        self.navigationController?
            .pushViewController(CouncilRegisterViewController(), animated: true)
    }
    //로그아웃 버튼 메서드
    @objc func LogoutBtnTapped() {
        //로그아웃시 서버에 로그아웃 시키겠다는 통신을 해야함.
        let urlString = "http://15.164.161.53:8082/api/v1/auth/logout"
        //유효하지 않은 Url 처리
        guard let url = URL(string: urlString) else {
            return
        }
        //URLSession을 이용해 통신
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let acToken = KeychainWrapper.standard.string(forKey: "AuthToken"), let rfToken = KeychainWrapper.standard.string(forKey: "refreshToken"){
            let requestBody : [String : Any] = [
                "accessToken" : acToken,
                "refreshToken" : rfToken
            ]
            print("accessToken : \(acToken), refreshToken : \(rfToken)")
            if let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: []){
                request.httpBody = jsonData
            }
        }
        // HTTP 헤더 요청 설정
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // 인증 토큰 설정
        if let token = KeychainWrapper.standard.string(forKey: "AuthToken"){
            //키체인에 저장된 토큰 값이 있을때
            print("토큰 값 : \(token)")
            request.setValue(token, forHTTPHeaderField: "Authorization")
        }else{
            //키체인에 저장된 토큰 값이 없을때
            print("토큰 값이 없습니다.")
        }
        //URLSession을 사용하여 서버와 통신
        let task = URLSession.shared.dataTask(with: request) { (data, response,error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else if let data = data {
                if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                    //서버로부터 받은 JSON 데이터 처리
                    print("Response JSON: \(responseJSON)")
                    print("로그아웃에 성공했습니다.")
                }
            }
        }
        task.resume() //요청 보내기
        //로그아웃 처리 메서드 추가. 키체인으로 저장된 토큰 삭제
        AuthenticationManager.logoutUser()
    }
}
