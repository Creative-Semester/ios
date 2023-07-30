//
//  MypageViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/07/23.
//

import UIKit
import SnapKit
class MypageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView : UITableView!
    //학생의 정보를 나타낼 텍스트를 가지고 있는 LabelView
    let StudentLabelView : UIView = {
       let StudentView = UIView()
        let Studenttitle = UILabel()
        let StudentInfo = UILabel()
//        Studenttitle.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        Studenttitle.text = "강민수 (학생)"
        Studenttitle.font = UIFont.boldSystemFont(ofSize: 20)
        Studenttitle.textAlignment = .left
        Studenttitle.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        Studenttitle.textColor = #colorLiteral(red: 0.1660557687, green: 0.4608593583, blue: 0.6628261209, alpha: 1)
        StudentView.addSubview(Studenttitle)
        
        StudentInfo.text = "지능기전공학부 스마트기기공학과"
        StudentInfo.font = UIFont.boldSystemFont(ofSize: 15)
        StudentInfo.textAlignment = .left
        StudentInfo.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        StudentInfo.textColor = #colorLiteral(red: 0.1660557687, green: 0.4608593583, blue: 0.6628261209, alpha: 1)
        StudentView.addSubview(StudentInfo)
        Studenttitle.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(50)
            make.leading.equalToSuperview().offset(0)
            make.height.equalTo(40)
        }
        StudentInfo.snp.makeConstraints{ (make) in
            make.top.equalTo(Studenttitle.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(0)
        }
        return StudentView
    }()
    
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
        MyWriteBtn.layer.cornerRadius = 30
        MyWriteBtn.layer.masksToBounds = true
        View.addSubview(MyWriteBtn)
        
        //내가 댓글 단 글을 보여줄 페이지로 이동할 버튼
        let MyComentBtn = UIButton()
        MyComentBtn.backgroundColor = .white
        MyComentBtn.setTitle("댓글 단 글", for: .normal)
        MyComentBtn.setTitleColor( #colorLiteral(red: 0.1660557687, green: 0.4608593583, blue: 0.6628261209, alpha: 1), for: .normal)
        MyComentBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        MyComentBtn.layer.cornerRadius = 30
        MyComentBtn.layer.masksToBounds = true
        View.addSubview(MyComentBtn)
        
        //학생회 신청 페이지로 넘어갈 버튼
        let CouncilRegisterBtn = UIButton()
        CouncilRegisterBtn.backgroundColor = .white
        CouncilRegisterBtn.setTitle("학생회 신청", for: .normal)
        CouncilRegisterBtn.setTitleColor(#colorLiteral(red: 0.1660557687, green: 0.4608593583, blue: 0.6628261209, alpha: 1), for: .normal)
        CouncilRegisterBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        CouncilRegisterBtn.layer.cornerRadius = 30
        CouncilRegisterBtn.layer.masksToBounds = true
        CouncilRegisterBtn.addTarget(self, action: #selector(CouncilRegisterTapped), for: .touchUpInside)
        View.addSubview(CouncilRegisterBtn)
        
        //로그아웃을 할 버튼 생성
        let LogoutBtn = UIButton()
        LogoutBtn.backgroundColor = .white
        LogoutBtn.setTitle("로그아웃", for: .normal)
        LogoutBtn.setTitleColor(#colorLiteral(red: 0.1660557687, green: 0.4608593583, blue: 0.6628261209, alpha: 1), for: .normal)
        LogoutBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        LogoutBtn.layer.cornerRadius = 30
        LogoutBtn.layer.masksToBounds = true
        View.addSubview(LogoutBtn)
        //SnapKit을 이용해 오토레이아웃
        MyWriteBtn.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(70)
        }
        MyComentBtn.snp.makeConstraints{ (make) in
            make.top.equalTo(MyWriteBtn.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(70)
        }
        CouncilRegisterBtn.snp.makeConstraints{ (make) in
            make.top.equalTo(MyComentBtn.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(70)
        }
        LogoutBtn.snp.makeConstraints{ (make) in
            make.top.equalTo(CouncilRegisterBtn.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(70)
        }
        return View
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
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
//        self.view.addSubview(StudentLabelView)
//        StudentLabelView.snp.makeConstraints{ (make) in
//            make.edges.equalToSuperview()
//                .inset(UIEdgeInsets(top: 60, left: 30, bottom: 350, right: 30))
//        }
//        self.view.addSubview(BtnView)
//        BtnView.snp.makeConstraints{ (make) in
//            make.edges.equalToSuperview()
//                .inset(UIEdgeInsets(top: 300, left: 30, bottom: 120, right: 30))
//        }
    }
    //버튼 액션 처리 메서드
    //학생회 신청 버튼 메서드
    @objc func CouncilRegisterTapped() {
        self.navigationController?
            .pushViewController(CouncilRegisterViewController(), animated: true)
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
            return 110
        } else if section == 1{
            return 450
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return StudentLabelView
        } else if section == 1{
            return BtnView
        }
        return nil
    }
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
