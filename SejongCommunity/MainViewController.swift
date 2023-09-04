//
//  MainViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/07/23.
//

import UIKit
import SnapKit
class MainViewController: UIViewController{
    var tableView : UITableView!
    //공지사항을 알리는 뷰를 생성
    var NotificationView : UIView = {
        let view = UIView()
        //뷰의 배경색을 하얀색으로 설정
        view.backgroundColor = #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        
        let spaceView = UIView()
        //뷰 안에 레이블 추가(제목)
        let Notificationtitle = UILabel()
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
        let Notification = UIButton()
        Notification.setTitle("앱 점검 공지(10.19 ~. ", for: .normal)
        Notification.backgroundColor =  #colorLiteral(red: 0.9670587182, green: 0.9670587182, blue: 0.967058599, alpha: 1)
        Notification.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
        Notification.addTarget(self, action: #selector(NotificationBtnTapped), for: .touchUpInside)
        view.addSubview(Notification)
        
        //뷰를 둥글게 만들기
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        //Snapkit을 이용해 오토레이아웃 설정
        Notificationtitle.snp.makeConstraints{ (make) in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(10)
            make.width.equalTo(view.snp.width).dividedBy(3)
        }
        Notification.snp.makeConstraints{ (make) in
            make.top.bottom.equalToSuperview().inset(0)
            make.width.equalTo(view.snp.width).dividedBy(2)
            make.leading.equalTo(Notificationtitle.snp.trailing).offset(15)
        }
        
        
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
        view.backgroundColor = .white
        // 자유게시판 버튼 생성
        let OpenBoardBtn = UIButton(type: .system)
        OpenBoardBtn.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        OpenBoardBtn.layer.cornerRadius = 10
        OpenBoardBtn.layer.masksToBounds = true
        let Openimage = UIImage(named: "OpenBoard")?.withRenderingMode(.alwaysOriginal)
        OpenBoardBtn.setImage(Openimage, for: .normal)
        OpenBoardBtn.imageView?.contentMode = .scaleAspectFit
        OpenBoardBtn.addTarget(self, action: #selector(OpenBoardBtnTapped), for: .touchUpInside)
//        view.addSubview(OpenBoardBtn)
        
        // 과소식게시판 버튼 생성
        let DepartBoardBtn = UIButton()
        let Departimage = UIImage(named: "DepartBoard")?.withRenderingMode(.alwaysOriginal)
        DepartBoardBtn.setImage(Departimage, for: .normal)
        DepartBoardBtn.imageView?.contentMode = .scaleAspectFit
        DepartBoardBtn.backgroundColor = #colorLiteral(red: 0.4761244059, green: 0.9626019597, blue: 0.514000833, alpha: 1)
        DepartBoardBtn.layer.cornerRadius = 10
        DepartBoardBtn.layer.masksToBounds = true
        DepartBoardBtn.addTarget(self, action: #selector(DepartBoardBtnTapped), for: .touchUpInside)
//        view.addSubview(DepartBoardBtn)
        
        // 수업게시판 버튼 생성
        let ClassBoardBtn = UIButton()
        let Classimage = UIImage(named: "ClassBoard")?.withRenderingMode(.alwaysOriginal)
        ClassBoardBtn.setImage(Classimage, for: .normal)
        ClassBoardBtn.imageView?.contentMode = .scaleAspectFit
        ClassBoardBtn.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        ClassBoardBtn.layer.cornerRadius = 10
        ClassBoardBtn.layer.masksToBounds = true
        ClassBoardBtn.addTarget(self, action: #selector(ClassBoardBtnTapped), for: .touchUpInside)
//        view.addSubview(ClassBoardBtn)
        
        // 학생회 버튼 생성
        let CouncilBoardBtn = UIButton()
        let Councilimage = UIImage(named: "CouncilBoard")?.withRenderingMode(.alwaysOriginal)
        CouncilBoardBtn.setImage(Councilimage, for: .normal)
        CouncilBoardBtn.imageView?.contentMode = .scaleAspectFit
        CouncilBoardBtn.backgroundColor = #colorLiteral(red: 1, green: 0.5347619653, blue: 0.7238742113, alpha: 1)
        CouncilBoardBtn.layer.cornerRadius = 10
        CouncilBoardBtn.layer.masksToBounds = true
        CouncilBoardBtn.addTarget(self, action: #selector(CouncilBoardBtnTapped), for: .touchUpInside)
//        view.addSubview(CouncilBoardBtn)
        
        // 뷰를 둥글게
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        //전체 스택뷰
        let AllStackView = UIStackView()
        AllStackView.axis = .vertical
        AllStackView.spacing = 20
        AllStackView.distribution = .fill
        AllStackView.alignment = .fill
        AllStackView.backgroundColor = .white
        
        //스택뷰1로 화면의 크기 설정
        let StackView1 = UIStackView()
        StackView1.alignment = .fill
        StackView1.backgroundColor = .white
        StackView1.distribution = .fill
        StackView1.spacing = 20
        StackView1.axis = .horizontal
        StackView1.addArrangedSubview(OpenBoardBtn)
        StackView1.addArrangedSubview(DepartBoardBtn)
        
        //스택뷰2로 화면의 크기 설정
        let StackView2 = UIStackView()
        StackView2.alignment = .fill
        StackView2.backgroundColor = .white
        StackView2.distribution = .fill
        StackView2.spacing = 20
        StackView2.axis = .horizontal
        StackView2.addArrangedSubview(ClassBoardBtn)
        StackView2.addArrangedSubview(CouncilBoardBtn)

        AllStackView.addArrangedSubview(StackView1)
        AllStackView.addArrangedSubview(StackView2)
        view.addSubview(AllStackView)
        //snapkit으로 오토레이아웃 설정
        AllStackView.snp.makeConstraints{(make) in
            make.top.bottom.leading.trailing.equalToSuperview().inset(0)
        }
        StackView1.snp.makeConstraints{(make) in
            make.leading.trailing.equalToSuperview().inset(0)
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(AllStackView.snp.height).dividedBy(2).offset(-10)
        }
        OpenBoardBtn.snp.makeConstraints{ (make) in
            make.leading.equalToSuperview().offset(0)
            make.width.equalTo(AllStackView.snp.width).dividedBy(2).offset(-10)
            make.top.equalToSuperview().offset(0)
        }
        DepartBoardBtn.snp.makeConstraints{ (make) in
            make.trailing.equalToSuperview().offset(-0)
            make.width.equalTo(AllStackView.snp.width).dividedBy(2).offset(-10)
            make.top.equalToSuperview().offset(0)
        }
        StackView2.snp.makeConstraints{ (make) in
            make.top.equalTo(StackView1.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(0)
            make.bottom.equalToSuperview().offset(-0)
            make.height.equalTo(AllStackView.snp.height).dividedBy(2).offset(-10)
        }
        ClassBoardBtn.snp.makeConstraints{(make) in
            make.leading.equalToSuperview().inset(0)
            make.width.equalTo(AllStackView.snp.width).dividedBy(2).offset(-10)
            make.bottom.equalToSuperview().offset(-0)
        }
        CouncilBoardBtn.snp.makeConstraints{(make) in
            make.bottom.equalToSuperview().offset(-0)
            make.width.equalTo(AllStackView.snp.width).dividedBy(2).offset(-10)
            make.trailing.equalToSuperview().offset(-0)
        }
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        let image = UIImage(named: "SideLogo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        let View = UIView()
        
        View.addSubview(imageView)
        self.navigationController?.navigationBar.barTintColor = .white
        let logoBarItem = UIBarButtonItem(customView: View)
        self.navigationItem.leftBarButtonItem = logoBarItem
        
        View.snp.makeConstraints{ (make) in
            make.width.equalTo(150)
            make.height.equalTo(60)
        }
        imageView.snp.makeConstraints{ (make) in
            make.edges.equalToSuperview()
        }
        title = "메인페이지"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] 
        
        let ScrollView = UIScrollView()
        self.view.addSubview(ScrollView)
        ScrollView.isScrollEnabled = true
        ScrollView.showsHorizontalScrollIndicator = false
        //Stack을 이용한 오토레이아웃 설정
        let StackView = UIStackView()
        StackView.alignment = .fill
        StackView.axis = .vertical
        StackView.distribution = .fill
        StackView.backgroundColor = .white
        StackView.spacing = 20
        StackView.addArrangedSubview(NotificationView)
        StackView.addArrangedSubview(CalenderView)
        StackView.addArrangedSubview(BoardView)
        ScrollView.addSubview(StackView)
        //Snapkit을 이용해 오토레이아웃 설정
        ScrollView.snp.makeConstraints{(make) in
            make.center.equalToSuperview()
            make.bottom.equalToSuperview().offset(-self.view.frame.height / 8.5)
            make.top.equalToSuperview().offset(self.view.frame.height / 8.5)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        StackView.snp.makeConstraints{ (make) in
            make.height.equalTo(ScrollView.snp.height)
            make.width.equalTo(ScrollView.snp.width)
            make.bottom.equalToSuperview().offset(-3)
            make.top.equalToSuperview().offset(0)
        }
        NotificationView.snp.makeConstraints{ (make) in
            make.height.equalTo(StackView.snp.height).dividedBy(12)
        }
        CalenderView.snp.makeConstraints{ (make) in
            make.top.equalTo(NotificationView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(StackView.snp.height).dividedBy(3.5)
        }
        BoardView.snp.makeConstraints{ (make) in
            make.top.equalTo(CalenderView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(0)
        }
    }
    //로고를 눌렀을때 메서드
    @objc func logoTapped() {
        
    }
    //버튼 액션 처리 메서드
    //자유게시판 버튼 액션 처리
    @objc func OpenBoardBtnTapped() {
        self.navigationController?.pushViewController(OpenBoardViewController(), animated: true)
    }
    //학생회공지사항, 투표 버튼 액션 처리
    @objc func DepartBoardBtnTapped() {
        self.navigationController?.pushViewController(DepartBoardViewController(), animated: true)
        //상세페이지로 들어갈때 탭바 숨기기
        tabBarController?.tabBar.isHidden = true
    }
    //수업게시판 버튼 액션 처리
    @objc func ClassBoardBtnTapped() {
        self.navigationController?.pushViewController(ClassBoardViewController(), animated: true)
    }
    //학생회 액션 처리
    @objc func CouncilBoardBtnTapped() {
        self.navigationController?.pushViewController(CouncilBoardViewController(), animated: true)
    }
    @objc func NotificationBtnTapped() {
        self.navigationController?.pushViewController(NotificationViewController(), animated: true)
    }
}
