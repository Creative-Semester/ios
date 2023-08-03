//
//  MainViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/07/23.
//

import UIKit
import SnapKit
class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView : UITableView!
    //공지사항을 알리는 뷰를 생성
    var NotificationView : UIView = {
        let view = UIView()
        //뷰의 배경색을 하얀색으로 설정
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        //뷰 안에 레이블 추가(제목)
        let Notificationtitle = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 40))
        Notificationtitle.text = "공지사항"
        Notificationtitle.textAlignment = .center
        Notificationtitle.backgroundColor = #colorLiteral(red: 0.9913799167, green: 0.5604230165, blue: 0.5662528872, alpha: 1)
        Notificationtitle.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        Notificationtitle.font = UIFont(name: "Bold", size: 20)
        //레이블을 둥글게 하기
        Notificationtitle.layer.cornerRadius = 10
        Notificationtitle.layer.masksToBounds = true
        view.addSubview(Notificationtitle)
        
        //뷰 안에 공지사항을 알리는 레이블 추가
        let Notification = UILabel(frame: CGRect(x:120, y:10, width:220, height:40))
        Notification.text = "사물함 재배치 투표기간(~2023.08.27)"
        Notification.backgroundColor = .white
        Notification.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        Notification.textAlignment = .center
        Notification.font = UIFont(name: "Bold", size: 20)
        view.addSubview(Notification)
        
        //뷰를 둥글게 만들기
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()
    
    // 캘린더 뷰 생성
    var CalenderView : UIView = {
       let view = UIImageView()
       //뷰의 배경색 설정
        view.backgroundColor = #colorLiteral(red: 1, green: 0.8216146827, blue: 0.8565195203, alpha: 1)
        view.image = UIImage(named: "Image")
        view.contentMode = .scaleAspectFill
        // 뷰를 둥글게
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
       return view
    }()
    // 게시판 뷰 생성
    var BoardView : UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        // 자유게시판 버튼 생성
        let OpenBoardBtn = UIButton(type: .system)
        OpenBoardBtn.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        OpenBoardBtn.layer.cornerRadius = 10
        OpenBoardBtn.layer.masksToBounds = true
        let Openimage = UIImage(named: "OpenBoard")?.withRenderingMode(.alwaysOriginal)
        OpenBoardBtn.setImage(Openimage, for: .normal)
        OpenBoardBtn.imageView?.contentMode = .scaleAspectFit
//        OpenBoardBtn.setTitle("자유게시판", for: .normal)
//        OpenBoardBtn.setTitleColor(.white, for: .normal)
//        OpenBoardBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        OpenBoardBtn.addTarget(self, action: #selector(OpenBoardBtnTapped), for: .touchUpInside)
        view.addSubview(OpenBoardBtn)
        
        // 과소식게시판 버튼 생성
        let DepartBoardBtn = UIButton()
        let Departimage = UIImage(named: "DepartBoard")?.withRenderingMode(.alwaysOriginal)
        DepartBoardBtn.setImage(Departimage, for: .normal)
        DepartBoardBtn.imageView?.contentMode = .scaleAspectFit
        DepartBoardBtn.backgroundColor = #colorLiteral(red: 0.4761244059, green: 0.9626019597, blue: 0.514000833, alpha: 1)
        DepartBoardBtn.layer.cornerRadius = 10
        DepartBoardBtn.layer.masksToBounds = true
        DepartBoardBtn.addTarget(self, action: #selector(DepartBoardBtnTapped), for: .touchUpInside)
        view.addSubview(DepartBoardBtn)
        
        // 수업게시판 버튼 생성
        let ClassBoardBtn = UIButton()
        let Classimage = UIImage(named: "ClassBoard")?.withRenderingMode(.alwaysOriginal)
        ClassBoardBtn.setImage(Classimage, for: .normal)
        ClassBoardBtn.imageView?.contentMode = .scaleAspectFit
        ClassBoardBtn.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        ClassBoardBtn.layer.cornerRadius = 10
        ClassBoardBtn.layer.masksToBounds = true
        ClassBoardBtn.addTarget(self, action: #selector(ClassBoardBtnTapped), for: .touchUpInside)
        view.addSubview(ClassBoardBtn)
        
        // 학생회 버튼 생성
        let CouncilBoardBtn = UIButton()
        let Councilimage = UIImage(named: "CouncilBoard")?.withRenderingMode(.alwaysOriginal)
        CouncilBoardBtn.setImage(Councilimage, for: .normal)
        CouncilBoardBtn.imageView?.contentMode = .scaleAspectFit
        CouncilBoardBtn.backgroundColor = #colorLiteral(red: 1, green: 0.5347619653, blue: 0.7238742113, alpha: 1)
        CouncilBoardBtn.layer.cornerRadius = 10
        CouncilBoardBtn.layer.masksToBounds = true
        CouncilBoardBtn.addTarget(self, action: #selector(CouncilBoardBtnTapped), for: .touchUpInside)
        view.addSubview(CouncilBoardBtn)
        
        // 뷰를 둥글게
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        //snapkit으로 오토레이아웃 설정
        OpenBoardBtn.snp.makeConstraints{ (make) in
//            make.top.equalToSuperview().offset(20)
//            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        DepartBoardBtn.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-0)
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        ClassBoardBtn.snp.makeConstraints { (make) in
//            make.bottom.equalToSuperview().offset(-0)
            make.top.equalTo(DepartBoardBtn.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(-0)
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        CouncilBoardBtn.snp.makeConstraints { (make) in
//            make.bottom.equalToSuperview().offset(-0)
            make.top.equalTo(DepartBoardBtn.snp.bottom).offset(30)
            make.trailing.equalToSuperview().offset(-0)
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(60)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(0)
        }
    }
    //버튼 액션 처리 메서드
    //자유게시판 버튼 액션 처리
    @objc func OpenBoardBtnTapped() {
        self.navigationController?.pushViewController(OpenBoardViewController(), animated: true)
    }
    //과소식 버튼 액션 처리
    @objc func DepartBoardBtnTapped() {
        self.navigationController?.pushViewController(DepartBoardViewController(), animated: true)
    }
    //수업게시판 버튼 액션 처리
    @objc func ClassBoardBtnTapped() {
        self.navigationController?.pushViewController(ClassBoardViewController(), animated: true)
    }
    //학생회 액션 처리
    @objc func CouncilBoardBtnTapped() {
        self.navigationController?.pushViewController(CouncilBoardViewController(), animated: true)
    }
    // MARK: - UITableViewDataSource
    //테이블 뷰의 섹션 개수를 반환하는 메서드
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    //각 센션별 행 개수를 반환하는 메서드
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    //테이블 뷰 셀을 반환하는 메서드
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 셀을 커스텀하여 사용하려면 UITablViewCell 대신 커스텀 셀을 반환하도록 구현
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
        // 셀에 필요한 내용 설정
        return cell
    }
    // 각 섹션 헤더 뷰의 높이를 반환하는 메서드
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 60
        } else if section == 1{
            return 200
        } else if section == 2{
            return 330
        }
        return 0
    }
    // 테이블 뷰의 각 센션에 헤더 뷰를 반환하는 메서드
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            return NotificationView
        } else if section == 1{
            return CalenderView
        } else if section == 2{
            return BoardView
        }
        return nil
    }
    
    // MARK: - UITableViewDelegate
    //테이블 뷰의 셀의 높이를 반환하는 메서드
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
