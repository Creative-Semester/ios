//
//  LoginViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/08/20.
//

import Foundation
import UIKit

class LoginViewController : UIViewController {
    // 보여지는 버튼 플래그
    var showflag = 0
    // 아이디와 비밀번호 입력 필드 선언
    private let idText = UITextField()
    private let passwordText = UITextField()
    // 로딩 인디케이터
    var loadingIndicator: UIActivityIndicatorView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated) // 백 버튼 숨기기
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated) // 화면을 벗어날 때 다시 나타내기
        //부모로 이동했을때 탭바를 다시 켬
        if isMovingFromParent {
            tabBarController?.tabBar.isHidden = false
            //메인뷰의 타이틀을 흰색으로
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
    }
    override func viewDidLoad() {
        print("LoginViewController - called()")
        super.viewDidLoad()
        self.view.backgroundColor = .white
        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.color = .gray
        loadingIndicator.center = self.view.center
        self.view.addSubview(loadingIndicator)
        setupTapGesture()
        setUpAutoLayout()
    }
    //로고 이미지
    private let imageView : UIView = {
        let View = UIImageView()
        let image = UIImage(named: "Logo")
        View.image = image
        View.contentMode = .scaleAspectFit
        View.backgroundColor = .white
        return View
    }()
    //아이디,비밀번호 입력 창
    private let TextView : UIStackView = {
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.spacing = 10
        StackView.distribution = .fill
        StackView.backgroundColor = .white
        
        
        return StackView
    }()
    //로그인 버튼
    private let LoginBtn : UIButton = {
       let Btn = UIButton()
        Btn.backgroundColor =  #colorLiteral(red: 1, green: 0.8216146827, blue: 0.8565195203, alpha: 1)
        Btn.setTitle("Login", for: .normal)
        Btn.setTitleColor(.black, for: .normal)
        Btn.layer.cornerRadius = 20
        Btn.layer.masksToBounds = true
        Btn.addTarget(self, action: #selector(LoginBtnTapped), for: .touchUpInside)
        
      return Btn
    }()
    //설명 라벨
    private let SecondLabel : UILabel = {
        let ExplainLabel = UILabel()
        ExplainLabel.text = "세종대학교 포털 아이디로 자동 로그인됩니다."
        ExplainLabel.textColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        ExplainLabel.font = UIFont.boldSystemFont(ofSize: 15)
        ExplainLabel.textAlignment = .center
        ExplainLabel.backgroundColor = .white
        
        return ExplainLabel
    }()
    //오토레이아웃을 위한 스택뷰
    private let StackView : UIStackView = {
       let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        view.backgroundColor = .white
        view.alignment = .fill
        
       return view
    }()
    //MARK: - Login Method
    //로그인 버튼 메서드
    @objc func LoginBtnTapped() {
        let id = idText.text ?? "" //아이디 가져오기
        let password = passwordText.text ?? "" //비밀번호 가져오기
        print("LoginBtnTapped - Called \(id), \(password)")
        self.loadingIndicator.startAnimating()
        // 이후 서버와 통신하기 위한 URL 설정
        let urlString = "https://keep-ops.shop/api/v1/auth/login"
        guard let url = URL(string: urlString) else {
                // 유효하지 않은 URL 처리
                return
            }
        let requestBody : [String : Any] = [
            "id" : id,
            "pw" : password
        ]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: []){
            request.httpBody = jsonData
        }
        do {
                // HTTP 요청 헤더 설정 (Content-Type: application/json)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                // URLSession을 사용하여 요청 전송
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        // 에러 처리
                        print("Error: \(error.localizedDescription)")
                        return
                    }

                    guard let httpResponse = response as? HTTPURLResponse,
                          (200...299).contains(httpResponse.statusCode) else {
                        // 서버 응답 상태 코드 처리
                        print("Invalid response status code - \(response)")
                        return
                    }
                    if let data = data {
                        do {
                            if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                                print("Response: \(jsonResponse)")
                                // 서버로부터 받은 응답 데이터를 파싱하여 로그인 결과 처리
                                // 예: 로그인 성공 또는 실패 처리
                                if let result = jsonResponse["result"] as? [String: Any],
                                   let accessToken = result["accessToken"] as? String,
                                   let refreshToken = result["refreshToken"] as? String,
                                   let userName = result["name"] as? String,
                                   let role = result["role"] as? String{
                                    UserDefaults.standard.set(userName, forKey: "userName")
                                    UserDefaults.standard.set(role, forKey: "role")
                                    print("검사들어갑니다")
                                    print("액세스토큰 - \(accessToken), 리프레시토큰 - \(refreshToken)")
                                    // 토큰 저장
                                    AuthenticationManager.saveAuthToken(token: accessToken, refresh: refreshToken)
                                    DispatchQueue.main.async {
                                        let mainTabBarController = MainTabBarController()
                                        mainTabBarController.setRootViewController()
                                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController, animated: true)
                                        if let sceneDeleagate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                                            sceneDeleagate.window?.makeKeyAndVisible()
                                        }
                                    }
                                    DispatchQueue.main.async {
                                        self.loadingIndicator.stopAnimating()
                                    }
                                }
                            } else {
                                print("Invalid JSON response")
                            }
                        } catch {
                            print("Error parsing response data: \(error.localizedDescription)")
                        }
                    }
                }
                // URLSession 작업 시작
                task.resume()
            } catch {
                print("Error encoding parameters: \(error.localizedDescription)")
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
}
extension LoginViewController{
    func setUpAutoLayout() {
        // 아이디 입력 필드 설정
        idText.backgroundColor = .white
        idText.textAlignment = .center
        idText.placeholder = "ID"
        idText.layer.borderWidth = 0.1
        idText.layer.cornerRadius = 20
        idText.layer.masksToBounds = true

        // 비밀번호 입력 필드 설정
        passwordText.backgroundColor = .white
        passwordText.textAlignment = .center
        passwordText.placeholder = "Passward"
//        passwordText.layer.borderWidth = 0.1
        passwordText.layer.cornerRadius = 20
        passwordText.layer.masksToBounds = true
        passwordText.isSecureTextEntry = true

        // 아이디와 비밀번호 입력 필드를 TextView에 추가
        TextView.addArrangedSubview(idText)
        // 버튼을 누르면 가려진 텍스트가 보여짐
        let miniTextView = UIView()
        miniTextView.backgroundColor = .white
        miniTextView.layer.borderWidth = 0.1
        miniTextView.layer.cornerRadius = 20
        let showpassward = UIButton()
        showpassward.setImage(UIImage(systemName: "lock"), for: .normal)
        showpassward.tintColor = .black
        showpassward.addTarget(self, action: #selector(showpasswardTapped), for: .touchUpInside)
        miniTextView.addSubview(passwordText)
        miniTextView.addSubview(showpassward)
        TextView.addArrangedSubview(miniTextView)
        let TextSpacing = UIView()
        TextSpacing.backgroundColor = .white
        TextView.addArrangedSubview(TextSpacing)
        //SnapKit AutoLayout
        idText.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(0)
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(50)
        }
        miniTextView.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(50)
        }
        passwordText.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(15)
            make.width.equalTo(miniTextView.snp.width).dividedBy(1.5)
            make.leading.equalToSuperview().offset(55)
        }
        showpassward.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-0)
            make.width.equalTo(miniTextView.snp.width).dividedBy(4)
        }
        TextSpacing.snp.makeConstraints{ (make) in
            make.leading.trailing.equalToSuperview().inset(0)
        }
        
        StackView.addArrangedSubview(imageView)
        let Spacing = UIView()
        Spacing.backgroundColor = .white
        
        let Spacing2 = UIView()
        Spacing2.backgroundColor = .white
        StackView.addArrangedSubview(Spacing)
        StackView.addArrangedSubview(TextView)
        StackView.addArrangedSubview(LoginBtn)
        StackView.addArrangedSubview(Spacing2)
        StackView.addArrangedSubview(SecondLabel)
        self.view.addSubview(StackView)
        
        //Snapkit AutoLayout
        StackView.snp.makeConstraints{ (make) in
            make.trailing.leading.equalToSuperview().inset(20)
            make.bottom.top.equalToSuperview().inset(self.view.frame.height / 8.5)
        }
        imageView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(20)
            make.trailing.leading.equalToSuperview().inset(0)
            make.height.equalTo(StackView.snp.height).dividedBy(3)
        }
        Spacing.snp.makeConstraints{ (make) in
            make.height.equalTo(StackView.snp.height).dividedBy(5)
        }
        TextView.snp.makeConstraints{ (make) in
            make.top.equalTo(Spacing.snp.bottom).offset(50)
            make.trailing.leading.equalToSuperview().inset(10)
        }
        LoginBtn.snp.makeConstraints{ (make) in
            make.top.equalTo(TextView.snp.bottom).offset(50)
            make.trailing.leading.equalToSuperview().inset(20)
            make.height.equalTo(StackView.snp.height).dividedBy(12)
        }
        Spacing2.snp.makeConstraints{ (make) in
            make.height.equalTo(10)
        }
        SecondLabel.snp.makeConstraints{ (make) in
            make.trailing.leading.equalToSuperview().inset(20)
        }
    }
    // 버튼을 누르면 비밀번호가 보임
    // 버튼을 여러번 클릭했을때 셀 flag
    @objc func showpasswardTapped() {
        if(showflag == 1) {
            passwordText.isSecureTextEntry = false
            showflag = 0
        }else if(showflag == 0){
            passwordText.isSecureTextEntry = true
            showflag = 1
        }
    }
}
