//
//  CouncilRegisterViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/07/29.
//

import Foundation
import UIKit

class CouncilRegisterViewController : UIViewController{
    //이 뷰의 타이틀과 학생회 신청에 대한 설명을 나타내는 뷰
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
        text.text = "학생회장, 학생회분들은\n@Sejong_Community\nor\naskdjflasjf@naver.com\n로 연락주시면 인증코드를 보내드리겠습니다."
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
    
    //인증코드를 입력받기 위한 뷰
    let CodeView : UIView = {
       let view = UIView()
        view.backgroundColor = .white
        //코드를 입력받기 위한 UITextField
        let CodeText = UITextField()
        CodeText.placeholder = "X6T3"
        CodeText.textAlignment = .center
        CodeText.font = UIFont.boldSystemFont(ofSize: 30)
        CodeText.borderStyle = .roundedRect
//        view.addSubview(CodeText)
        view.layer.cornerRadius = 30
        view.layer.masksToBounds = true
        
        //인증받기 버튼
        let CodeBtn = UIButton()
        CodeBtn.backgroundColor = #colorLiteral(red: 0.9744978547, green: 0.7001121044, blue: 0.6978833079, alpha: 1)
        CodeBtn.setTitle("인증받기", for: .normal)
        CodeBtn.setTitleColor(.black, for: .normal)
        CodeBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        CodeBtn.layer.cornerRadius = 20
        CodeBtn.layer.masksToBounds = true
        CodeBtn.addTarget(self, action: #selector(CodeBtnTapped), for: .touchUpInside)
//        view.addSubview(CodeBtn)
        //StackView로 오토레이아웃 설정
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.spacing = 20
        StackView.distribution = .fill
        StackView.alignment = .fill
        StackView.backgroundColor = .white
        StackView.addArrangedSubview(CodeText)
        StackView.addArrangedSubview(CodeBtn)
        let Spacing = UIView()
        Spacing.backgroundColor = .white
        StackView.addArrangedSubview(Spacing)
        view.addSubview(StackView)
        //SnapKit으로 오토레이아웃 설정
        StackView.snp.makeConstraints{ (make) in
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
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .red
        title = "학생회 신청"
        
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
        
    }
}
