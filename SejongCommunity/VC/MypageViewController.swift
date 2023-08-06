//
//  MypageViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/07/23.
//

import UIKit
import SnapKit
class MypageViewController: UIViewController{
    var tableView : UITableView!
    //학생의 정보를 나타낼 텍스트를 가지고 있는 LabelView
    let StudentLabelView : UIView = {
       let StudentView = UIView()
        let Studenttitle = UILabel()
        let StudentInfo = UILabel()
        Studenttitle.text = "강민수 (학생)"
        Studenttitle.font = UIFont.boldSystemFont(ofSize: 20)
        Studenttitle.textAlignment = .left
        Studenttitle.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        Studenttitle.textColor = #colorLiteral(red: 0.1660557687, green: 0.4608593583, blue: 0.6628261209, alpha: 1)
        
        StudentInfo.text = "지능기전공학부 스마트기기공학과"
        StudentInfo.font = UIFont.boldSystemFont(ofSize: 15)
        StudentInfo.textAlignment = .left
        StudentInfo.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        StudentInfo.textColor = #colorLiteral(red: 0.1660557687, green: 0.4608593583, blue: 0.6628261209, alpha: 1)
        
        //StackView를 이용한 오토레이아웃 설정
        let StackView = UIStackView()
        StackView.alignment = .fill
        StackView.distribution = .fill
        StackView.axis = .vertical
        StackView.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        StackView.spacing = 30
        StackView.addArrangedSubview(Studenttitle)
        StackView.addArrangedSubview(StudentInfo)
        StudentView.addSubview(StackView)
        
        //SnapKit을 이용한 오토레이아웃 설정
        StackView.snp.makeConstraints{(make) in
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
        
        //내가 댓글 단 글을 보여줄 페이지로 이동할 버튼
        let MyComentBtn = UIButton()
        MyComentBtn.backgroundColor = .white
        MyComentBtn.setTitle("댓글 단 글", for: .normal)
        MyComentBtn.setTitleColor( #colorLiteral(red: 0.1660557687, green: 0.4608593583, blue: 0.6628261209, alpha: 1), for: .normal)
        MyComentBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        MyComentBtn.layer.cornerRadius = 30
        MyComentBtn.layer.masksToBounds = true
        
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
        
        //StackView를 이용해 오토레이아웃 설정
        let ScrollView = UIScrollView()
        self.view.addSubview(ScrollView)
        ScrollView.showsHorizontalScrollIndicator = false
        ScrollView.isScrollEnabled = true
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.distribution = .fill
        StackView.alignment = .fill
        StackView.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        StackView.spacing = 20
        StackView.addArrangedSubview(StudentLabelView)
        StackView.addArrangedSubview(BtnView)
        ScrollView.addSubview(StackView)
        
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
    //버튼 액션 처리 메서드
    //학생회 신청 버튼 메서드
    @objc func CouncilRegisterTapped() {
        self.navigationController?
            .pushViewController(CouncilRegisterViewController(), animated: true)
    }
}
