//
//  MainViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/07/23.
//

import UIKit
import SnapKit
class MainViewController: UIViewController {
    
    //공지사항을 알리는 뷰를 생성
    var NotificationView : UIView = {
        let view = UIView()
        //뷰의 배경색을 하얀색으로 설정
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        //뷰 안에 레이블 추가(제목)
        let Notificationtitle = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 40))
        Notificationtitle.text = "공지사항"
        Notificationtitle.textAlignment = .center
        Notificationtitle.backgroundColor = #colorLiteral(red: 1, green: 0.4660889506, blue: 0.5009844303, alpha: 1)
        Notificationtitle.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        Notificationtitle.font = UIFont(name: "Bold", size: 20)
        //레이블을 둥글게 하기
        Notificationtitle.layer.cornerRadius = 10
        Notificationtitle.layer.masksToBounds = true
        view.addSubview(Notificationtitle)
        
        //뷰 안에 공지사항을 알리는 레이블 추가
        let Notification = UILabel(frame: CGRect(x:120, y:10, width:220, height:40))
        Notification.text = "어플 관련 업데이트 소식(앱 공지)"
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
       let view = UIView()
       //뷰의 배경색 설정
        view.backgroundColor = #colorLiteral(red: 1, green: 0.8216146827, blue: 0.8565195203, alpha: 1)
        
        // 뷰를 둥글게
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
       return view
    }()
//    override func viewWillAppear(_ animated: Bool) {
//        <#code#>
//    }
    
    // 게시판 뷰 생성
    var BoardView : UIView = {
       let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        // 자유게시판 버튼 생성
        let OpenBoardBtn = UIButton(type: .system)
        OpenBoardBtn.setTitle("자유게시판", for: .normal)
        OpenBoardBtn.setTitleColor(.white, for: .normal)
        OpenBoardBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        OpenBoardBtn.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        OpenBoardBtn.snp.makeConstraints{ (make) in
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        OpenBoardBtn.layer.cornerRadius = 10
        OpenBoardBtn.layer.masksToBounds = true
        view.addSubview(OpenBoardBtn)
        
        // 과소식게시판 버튼 생성
        let DepartBoardBtn = UIButton(frame: CGRect(x: 200, y: 0, width: 150, height: 150))
        DepartBoardBtn.setTitle("과 소식", for: .normal)
        DepartBoardBtn.setTitleColor(.white, for: .normal)
        DepartBoardBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        DepartBoardBtn.backgroundColor = #colorLiteral(red: 0.4761244059, green: 0.9626019597, blue: 0.514000833, alpha: 1)
        DepartBoardBtn.layer.cornerRadius = 10
        DepartBoardBtn.layer.masksToBounds = true
        view.addSubview(DepartBoardBtn)
        
        // 수업게시판 버튼 생성
        let ClassBoardBtn = UIButton(frame: CGRect(x: 0, y: 200, width: 150, height: 150))
        ClassBoardBtn.setTitle("수업게시판", for: .normal)
        ClassBoardBtn.setTitleColor(.white, for: .normal)
        ClassBoardBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        ClassBoardBtn.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        ClassBoardBtn.layer.cornerRadius = 10
        ClassBoardBtn.layer.masksToBounds = true
        view.addSubview(ClassBoardBtn)
        
        // 학생회 버튼 생성
        let CouncilBoardBtn = UIButton(frame: CGRect(x: 200, y: 200, width: 150, height: 150))
        CouncilBoardBtn.setTitle("학생회", for: .normal)
        CouncilBoardBtn.setTitleColor(.white, for: .normal)
        CouncilBoardBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        CouncilBoardBtn.backgroundColor = #colorLiteral(red: 1, green: 0.5347619653, blue: 0.7238742113, alpha: 1)
        CouncilBoardBtn.layer.cornerRadius = 10
        CouncilBoardBtn.layer.masksToBounds = true
        view.addSubview(CouncilBoardBtn)
        
        // 뷰를 둥글게
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        
        self.view.addSubview(NotificationView)
            NotificationView.snp.makeConstraints{ (make) in
                make.edges.equalToSuperview().inset(UIEdgeInsets(top: 60, left: 20, bottom: 730, right: 20))
            }
        self.view.addSubview(CalenderView)
            CalenderView.snp.makeConstraints{ (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 140, left: 20, bottom: 520, right: 20))
        }
        self.view.addSubview(BoardView)
        BoardView.snp.makeConstraints{ (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 370, left: 20, bottom: 120, right: 20))
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        <#code#>
//    }
}
