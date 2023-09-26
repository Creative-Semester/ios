//
//  MainViewController.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/07/23.
//

import UIKit
import SnapKit
import WebKit
//캘린더 뷰 추가
import FSCalendar
class MainViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource{
    // 또는 viewWillAppear 메서드에서 설정
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            // 다시 탭 바를 표시
            tabBarController?.tabBar.isHidden = false
        }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    var tableView : UITableView!
    //공지사항을 알리는 뷰를 생성
    var NotificationView : UIButton = {
        let view = UIButton()
        //뷰의 배경색을 하얀색으로 설정
        view.backgroundColor = #colorLiteral(red: 0.9629544616, green: 0.9693544507, blue: 0.9692414403, alpha: 1)
        //뷰 안에 레이블 추가(제목)
        let Notificationtitle = UIImageView()
        Notificationtitle.image = UIImage(systemName: "megaphone")
        Notificationtitle.backgroundColor = .white
        Notificationtitle.tintColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        Notificationtitle.backgroundColor = #colorLiteral(red: 0.9629544616, green: 0.9693544507, blue: 0.9692414403, alpha: 1)
        view.addSubview(Notificationtitle)
        
        //뷰 안에 공지사항을 알리는 레이블 추가
        let Notification = UIButton()
        Notification.setTitle("앱 점검 공지 매주 목요일 13시 ~ 15시...", for: .normal)
        Notification.backgroundColor = #colorLiteral(red: 0.9629544616, green: 0.9693544507, blue: 0.9692414403, alpha: 1)
        Notification.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .normal)
        Notification.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        Notification.addTarget(self, action: #selector(NotificationBtnTapped), for: .touchUpInside)
        view.addSubview(Notification)
        
        //뷰를 둥글게 만들기
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        //Snapkit을 이용해 오토레이아웃 설정
        Notificationtitle.snp.makeConstraints{ (make) in
            make.top.bottom.equalToSuperview().inset(15)
            make.leading.equalToSuperview().offset(15)
            make.width.equalTo(23)
        }
        Notification.snp.makeConstraints{ (make) in
            make.top.bottom.equalToSuperview().inset(0)
            make.width.equalTo(view.snp.width).dividedBy(1.2)
            make.leading.equalTo(Notificationtitle.snp.trailing).offset(10)
        }
        
        
        return view
    }()
    // 현재 표시 중인 이미지의 인덱스를 추적하기 위한 변수를 추가합니다.
    var currentImageIndex = 0
    // 이미지 파일 이름 배열
    let imageNames = ["Image1", "Image2", "image3", "image4"]
    // 타이머
    var slideshowTimer: Timer?
    // 웹 뷰 생성
    var CalenderView: UIButton!
    // 게시판 뷰 생성
    var BoardView : UIView = {
       let view = UIView()
        view.backgroundColor = .white
        // 자유게시판 버튼 생성
        let OpenBoardBtn = UIButton()
        OpenBoardBtn.layer.cornerRadius = 30
        OpenBoardBtn.layer.masksToBounds = true
        let Openimage = UIImage(named: "icon1")
        OpenBoardBtn.setImage(Openimage, for: .normal)
        OpenBoardBtn.contentMode = .scaleAspectFit
        OpenBoardBtn.addTarget(self, action: #selector(OpenBoardBtnTapped), for: .touchUpInside)
        OpenBoardBtn.backgroundColor = .white
        
        // 학생회 공지사항/투표 버튼 생성
        let DepartBoardBtn = UIButton()
        let Departimage = UIImage(named: "icon2")
        DepartBoardBtn.setImage(Departimage, for: .normal)
        DepartBoardBtn.contentMode = .scaleAspectFit
        DepartBoardBtn.layer.cornerRadius = 30
        DepartBoardBtn.layer.masksToBounds = true
        DepartBoardBtn.addTarget(self, action: #selector(DepartBoardBtnTapped), for: .touchUpInside)
        DepartBoardBtn.backgroundColor = .white
        
        // 교수게시판 버튼 생성
        let ClassBoardBtn = UIButton()
        let Classimage = UIImage(named: "icon3")
        ClassBoardBtn.setImage(Classimage, for: .normal)
        ClassBoardBtn.contentMode = .scaleAspectFit
        ClassBoardBtn.layer.cornerRadius = 30
        ClassBoardBtn.layer.masksToBounds = true
        ClassBoardBtn.addTarget(self, action: #selector(ClassBoardBtnTapped), for: .touchUpInside)
        ClassBoardBtn.backgroundColor = .white
        
        // 학생회 버튼 생성
        let CouncilBoardBtn = UIButton()
        let Councilimage = UIImage(named: "icon4")
        CouncilBoardBtn.setImage(Councilimage, for: .normal)
        CouncilBoardBtn.contentMode = .scaleAspectFit
        CouncilBoardBtn.layer.cornerRadius = 30
        CouncilBoardBtn.layer.masksToBounds = true
        CouncilBoardBtn.addTarget(self, action: #selector(CouncilBoardBtnTapped), for: .touchUpInside)
        CouncilBoardBtn.backgroundColor = .white
        
        //전체 스택뷰
        let AllStackView = UIStackView()
        AllStackView.axis = .vertical
        AllStackView.spacing = 3
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
        StackView1.addArrangedSubview(ClassBoardBtn)
        StackView1.addArrangedSubview(CouncilBoardBtn)
        //스택뷰2로 화면의 크기 설정
        let StackView2 = UIStackView()
        let OpenBoardLabel = UILabel()
        OpenBoardLabel.text = "자유게시판"
        OpenBoardLabel.textAlignment = .center
        OpenBoardLabel.font = UIFont.systemFont(ofSize: 12)
        let DepartBoardLabel = UILabel()
        DepartBoardLabel.text = "학생회 공지"
        DepartBoardLabel.textAlignment = .center
        DepartBoardLabel.font = UIFont.systemFont(ofSize: 12)
        let ClassBoardLabel = UILabel()
        ClassBoardLabel.textAlignment = .center
        ClassBoardLabel.text = "교수게시판"
        ClassBoardLabel.font = UIFont.systemFont(ofSize: 12)
        let CouncilBoardLabel = UILabel()
        CouncilBoardLabel.text = "학생회"
        CouncilBoardLabel.textAlignment = .center
        CouncilBoardLabel.font = UIFont.systemFont(ofSize: 12)
        StackView2.alignment = .fill
        StackView2.backgroundColor = .white
        StackView2.distribution = .fill
        StackView2.spacing = 20
        StackView2.axis = .horizontal
        StackView2.addArrangedSubview(OpenBoardLabel)
        StackView2.addArrangedSubview(DepartBoardLabel)
        StackView2.addArrangedSubview(ClassBoardLabel)
        StackView2.addArrangedSubview(CouncilBoardLabel)
        view.addSubview(StackView1)
        view.addSubview(StackView2)
        //snapkit으로 오토레이아웃 설정
        StackView1.snp.makeConstraints{(make) in
            make.leading.trailing.top.equalToSuperview().inset(0)
        }
        OpenBoardBtn.snp.makeConstraints{ (make) in
            make.leading.equalToSuperview().offset(0)
            make.width.equalTo(view.snp.width).dividedBy(4).inset(7.5)
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(view.snp.width).dividedBy(4).inset(7.5)
        }
        DepartBoardBtn.snp.makeConstraints{ (make) in
            make.width.equalTo(view.snp.width).dividedBy(4).inset(7.5)
            make.top.equalToSuperview().offset(0)
            make.height.equalTo(view.snp.width).dividedBy(4).inset(7.5)
        }
        ClassBoardBtn.snp.makeConstraints{(make) in
            make.width.equalTo(view.snp.width).dividedBy(4).inset(7.5)
            make.bottom.equalToSuperview().offset(-0)
            make.height.equalTo(view.snp.width).dividedBy(4).inset(7.5)
        }
        CouncilBoardBtn.snp.makeConstraints{(make) in
            make.bottom.equalToSuperview().offset(-0)
            make.width.equalTo(view.snp.width).dividedBy(4).inset(7.5)
            make.height.equalTo(view.snp.width).dividedBy(4).inset(7.5)
        }
        StackView2.snp.makeConstraints{ (make) in
            make.top.equalTo(CouncilBoardBtn.snp.bottom).offset(0)
            make.leading.trailing.equalToSuperview().inset(0)
        }
        OpenBoardLabel.snp.makeConstraints{(make) in
            make.leading.equalToSuperview().offset(0)
            make.width.equalTo(view.snp.width).dividedBy(4).inset(7.5)
            make.top.equalToSuperview().offset(0)
        }
        DepartBoardLabel.snp.makeConstraints{(make) in
            make.width.equalTo(view.snp.width).dividedBy(4).inset(7.5)
            make.top.equalToSuperview().offset(0)
        }
        ClassBoardLabel.snp.makeConstraints{ (make) in
            make.width.equalTo(view.snp.width).dividedBy(4).inset(7.5)
            make.bottom.equalToSuperview().offset(-0)
        }
        CouncilBoardLabel.snp.makeConstraints{(make) in
            make.bottom.equalToSuperview().offset(-0)
            make.width.equalTo(view.snp.width).dividedBy(4).inset(7.5)
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
        tabBarController?.tabBar.isHidden = false
        View.addSubview(imageView)
        self.navigationController?.navigationBar.barTintColor = .white
        let logoBarItem = UIBarButtonItem(customView: View)
        self.navigationItem.leftBarButtonItem = logoBarItem
        self.navigationController?.isNavigationBarHidden = false
        View.snp.makeConstraints{ (make) in
            make.width.equalTo(150)
            make.height.equalTo(80)
        }
        imageView.snp.makeConstraints{ (make) in
            make.edges.equalToSuperview()
        }
        title = "메인페이지"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white] 
        //뷰의 배경색 설정
        CalenderView = UIButton()
        CalenderView.backgroundColor = .white
        CalenderView.addTarget(self, action: #selector(WebViewBtnTapped), for: .touchUpInside)
        CalenderView.setImage(UIImage(named: self.imageNames[self.currentImageIndex]), for: .normal)
        CalenderView.layer.masksToBounds = true
        CalenderView.layer.cornerRadius = 10
        CalenderView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // 시작할 때 이미지 설정
        updateImage()
        // 슬라이드 쇼 타이머 설정
        startSlideshow()
        
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
        let BoardSummary = FSCalendar()
        BoardSummary.delegate = self
        BoardSummary.dataSource = self
        BoardSummary.backgroundColor = .white// 캘린더 뷰의 배경색 설정
        BoardSummary.appearance.titleDefaultColor = .black // 달력의 평일 날짜 색
        BoardSummary.appearance.titleWeekendColor = .red // 달력의 토일 날짜 색
        BoardSummary.appearance.headerTitleColor = .systemRed // 년도, 월의 색
        BoardSummary.appearance.weekdayTextColor = .orange // 요일 글자 색
        let cv = UIView()
        let cvimage = UIImageView(image : UIImage(systemName: "pencil.tip.crop.circle"))
        cvimage.tintColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        let cvtext = UILabel()
        cvtext.text = "두드림"
        cvtext.textColor = .black
        cvtext.textAlignment = .left
        cvtext.font = UIFont.boldSystemFont(ofSize: 18)
        cv.addSubview(cvimage)
        cv.addSubview(cvtext)
        cvimage.snp.makeConstraints{ (make) in
            make.leading.equalToSuperview().offset(0)
        }
        cvtext.snp.makeConstraints{ (make) in
            make.leading.equalTo(cvimage.snp.trailing).offset(5)
        }
        StackView.addArrangedSubview(NotificationView)
        StackView.addArrangedSubview(cv)
        StackView.addArrangedSubview(CalenderView)
        StackView.addArrangedSubview(BoardView)
        StackView.addArrangedSubview(BoardSummary)
        ScrollView.addSubview(StackView)
        //Snapkit을 이용해 오토레이아웃 설정
        ScrollView.snp.makeConstraints{(make) in
            make.center.equalToSuperview()
            make.bottom.equalToSuperview().offset(-self.view.frame.height / 8.5)
            make.top.equalToSuperview().offset(self.view.frame.height / 8.5)
            make.trailing.leading.equalToSuperview().inset(20)
        }
        StackView.snp.makeConstraints{ (make) in
            make.width.equalTo(ScrollView.snp.width)
            make.height.equalTo(ScrollView.snp.height)
            make.bottom.equalToSuperview().offset(-3)
            make.top.equalToSuperview().offset(0)
        }
        NotificationView.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(5)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(50)
        }
        cv.snp.makeConstraints{ (make) in
            make.top.equalTo(NotificationView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(0)
            make.height.equalTo(30)
        }
        CalenderView.snp.makeConstraints{ (make) in
            make.top.equalTo(cv.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(StackView.snp.height).dividedBy(3.2)
        }
        BoardView.snp.makeConstraints{ (make) in
            make.top.equalTo(CalenderView.snp.bottom).offset(0)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalToSuperview().dividedBy(7)
        }
        BoardSummary.snp.makeConstraints{ (make) in
            make.top.equalTo(BoardView.snp.bottom).offset(10)
//            make.height.equalTo(view.frame.height / 4)
            make.bottom.equalToSuperview().offset(-10)
            make.leading.trailing.equalToSuperview().inset(0)
        }
    }
    // 이미지 변경 메서드
    func updateImage() {
        CalenderView.setImage(UIImage(named: imageNames[currentImageIndex]), for: .normal)
    }
    // 슬라이드 쇼 시작 메서드
    func startSlideshow() {
        slideshowTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
    }
    // 다음 이미지로 넘어가는 메서드
    @objc func nextImage() {
        currentImageIndex = (currentImageIndex + 1) % imageNames.count
        updateImage()
    }
    // 슬라이드 쇼 중지 메서드
    func stopSlideshow() {
        slideshowTimer?.invalidate()
        slideshowTimer = nil
    }
    //웹으로 이동하는 메서드
    @objc func WebViewBtnTapped() {
        print("WebViewBtnTapped - called()")
        // 뷰 컨트롤러를 표시
        self.navigationController?.pushViewController(WebViewController(), animated: true)
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
        self.navigationController?.pushViewController(ProfessorBoardViewController(), animated: true)
    }
    //학생회 액션 처리
    @objc func CouncilBoardBtnTapped() {
        self.navigationController?.pushViewController(CouncilBoardViewController(), animated: true)
    }
    @objc func NotificationBtnTapped() {
        self.navigationController?.pushViewController(NotificationViewController(), animated: true)
    }
    @objc func AlertBtnTapped() {
        print("AlertBtnTapped - called()")
    }
}
