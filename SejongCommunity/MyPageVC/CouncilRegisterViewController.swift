//
//  CouncilRegisterViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/07/29.
//

import Foundation
import UIKit

class CouncilRegisterViewController : UIViewController,UITableViewDelegate, UITableViewDataSource {
    var tableView : UITableView!
    //이 뷰의 타이틀과 학생회 신청에 대한 설명을 나타내는 뷰
    let ExplainView : UIView = {
       let view = UIView()
        //타이틀
        let title = UILabel()
        title.backgroundColor = .white
        title.text = "학생회 신청"
        title.textColor =  #colorLiteral(red: 0.1660557687, green: 0.4608593583, blue: 0.6628261209, alpha: 1)
        title.textAlignment = .center
        title.font = UIFont.boldSystemFont(ofSize: 25)
        view.addSubview(title)
        
        //학생회 신청에 대한 설명
        let explain = UILabel()
        explain.text = "학생회 신청을 위한 페이지입니다."
        explain.textColor = #colorLiteral(red: 0.6369416118, green: 0.7151209116, blue: 0.818664968, alpha: 1)
        explain.textAlignment = .center
        explain.font = UIFont.boldSystemFont(ofSize: 15)
        view.addSubview(explain)
        let explain2 = UILabel()
        explain2.text = "일반 학생은 신청시 확인 후 기각됩니다."
        explain2.textColor = #colorLiteral(red: 0.6369416118, green: 0.7151209116, blue: 0.818664968, alpha: 1)
        explain2.textAlignment = .center
        explain2.font = UIFont.boldSystemFont(ofSize: 15)
        view.addSubview(explain2)
        
        //Snapkit을 이용해 오토레이아웃 설정
        title.snp.makeConstraints{(make) in
            make.top.equalToSuperview().offset(30)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        explain.snp.makeConstraints{(make) in
            make.top.equalTo(title.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        explain2.snp.makeConstraints{(make) in
            make.top.equalTo(explain.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        
        return view
    }()
    
    //메일 주소를 적어둘 뷰
    let MailView : UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9680508971, green: 0.9680508971, blue: 0.9680508971, alpha: 1)
        let text1 = UILabel()
        text1.text = "학생회장, 학생회분들은"
        text1.textColor = #colorLiteral(red: 0.6696126461, green: 0.6785762906, blue: 0.6784186959, alpha: 1)
        text1.textAlignment = .center
        view.addSubview(text1)
        let text2 = UILabel()
        text2.text = "@Sejong_Community\n"
        text2.textColor = #colorLiteral(red: 0.6696126461, green: 0.6785762906, blue: 0.6784186959, alpha: 1)
        text2.textAlignment = .center
        view.addSubview(text2)
        let text3 = UILabel()
        text3.text = "or"
        text3.textColor = #colorLiteral(red: 0.6696126461, green: 0.6785762906, blue: 0.6784186959, alpha: 1)
        text3.textAlignment = .center
        view.addSubview(text3)
        let text4 = UILabel()
        text4.text = "askdjflasjf@naver.com"
        text4.textColor = #colorLiteral(red: 0.6696126461, green: 0.6785762906, blue: 0.6784186959, alpha: 1)
        text4.textAlignment = .center
        view.addSubview(text4)
        let text5 = UILabel()
        text5.text = "로 연락주시면 인증코드를 보내드리겠습니다."
        text5.textColor = #colorLiteral(red: 0.6696126461, green: 0.6785762906, blue: 0.6784186959, alpha: 1)
        text5.textAlignment = .center
        view.addSubview(text5)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        
        //Snapkit을 이용해 오토레이아웃 설정
        text1.snp.makeConstraints{(make) in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        text2.snp.makeConstraints{(make) in
            make.top.equalTo(text1.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        text3.snp.makeConstraints{(make) in
            make.top.equalTo(text2.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        text4.snp.makeConstraints{(make) in
            make.top.equalTo(text3.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        text5.snp.makeConstraints{(make) in
            make.top.equalTo(text4.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(0)
        }
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
        view.addSubview(CodeText)
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
        view.addSubview(CodeBtn)
        
        //SnapKit으로 오토레이아웃 설정
        CodeText.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(90)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        CodeBtn.snp.makeConstraints{ (make) in
            make.top.equalTo(CodeText.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(60)
        }
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .red
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(0)
        }
    }
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
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
            return 150
        } else if section == 1{
            return 200
        } else if section == 2{
            return 250
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return ExplainView
        } else if section == 1{
            return MailView
        } else if section == 2{
            return CodeView
        }
        return nil
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    //인증받기 버튼 액션
    @objc func CodeBtnTapped() {
        
    }
}
