//
//  ProfessorInfoViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/09/11.
//

import UIKit
import SnapKit

class ProfessorInfoViewController: UIViewController {
    
    var professorId: Int?
    private var professorLectureList: [ProfessorLecture]?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()

//        scrollView.showsVerticalScrollIndicator = false
        
        return scrollView
    }()

    private let professorImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "professor")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 20
        
        return imageView
    }()
    
    private let professorNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "김세원"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 4
        
        return stackView
    }()
    
    private let professorLocationLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "AI센터 524호"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let professorNumberLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "02-6935-2678"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let professorEmailLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "sewonkim@sejong.ac.kr"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let professorMajorLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Autonomous Ship"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let professorRoomLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Autonomous Shipping Lab"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let lineView: UIView = {
       let view = UIView()
        
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    private let professorClassTitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "교수님 강의 게시판"
        label.numberOfLines = 0
        
        return label
    }()
    
    private let professorClassTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        
        tableView.backgroundColor = .white
        tableView.isScrollEnabled = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "교수게시판"
        
        professorClassTableView.dataSource = self
        professorClassTableView.delegate = self
        professorClassTableView.register(ProfessorClassTableViewCell.self, forCellReuseIdentifier: "ProfessorClassTableViewCell")
        
        getProfessorLectureData()
        calculateScrollViewHeight()
        setupLayout()
    }
    
    // 스크롤 뷰의 높이 계산
    func calculateScrollViewHeight() {
        let infoViewHeight: CGFloat = 203
        let cellCount: CGFloat  = CGFloat(professorLectureList?.count ?? 0)
        let cellHeight: CGFloat  = 60
        
        scrollView.snp.makeConstraints { make in
            make.height.equalTo(max(cellCount * cellHeight + infoViewHeight, UIScreen.main.bounds.height))
        }
    }
    

    func setupLayout() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        scrollView.addSubview(professorImageView)
        professorImageView.snp.makeConstraints{ make in
            make.top.equalTo(scrollView.snp.top).offset(14)
            make.leading.equalTo(scrollView.snp.leading).offset(14)
            make.height.width.equalTo(130)
        }
        
        scrollView.addSubview(professorNameLabel)
        professorNameLabel.snp.makeConstraints{ make in
            make.top.equalTo(professorImageView.snp.top).offset(4)
            make.leading.equalTo(professorImageView.snp.trailing).offset(14)
            make.height.equalTo(20)
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints{ make in
            make.top.equalTo(professorNameLabel.snp.bottom).offset(14)
            make.leading.equalTo(professorImageView.snp.trailing).offset(14)
            make.trailing.equalTo(scrollView.snp.trailing).inset(14)
        }
        stackView.addArrangedSubview(professorLocationLabel)
        stackView.addArrangedSubview(professorNumberLabel)
        stackView.addArrangedSubview(professorEmailLabel)
        stackView.addArrangedSubview(professorMajorLabel)
        stackView.addArrangedSubview(professorRoomLabel)
        
        
        scrollView.addSubview(lineView)
        lineView.snp.makeConstraints{ make in
            make.top.equalTo(professorImageView.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(14)
            make.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
        
        scrollView.addSubview(professorClassTitleLabel)
        professorClassTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(lineView.snp.bottom).offset(14)
            make.leading.equalTo(scrollView.snp.leading).offset(14)
        }
        
        scrollView.addSubview(professorClassTableView)
        professorClassTableView.snp.makeConstraints{ make in
            make.top.equalTo(professorClassTitleLabel.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview().inset(14)
            make.centerX.equalToSuperview()
            make.height.equalTo(60 * 15)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
    }
    
    func getProfessorLectureData() {
        
        guard let professorId = professorId else { return }
        
        ProfessorLectureService.shared.getProfessorLectureInfo(professorId: professorId, page: 0) { response in
            switch response {
                
            case .success(let data):
                guard let infoData = data as? ProfessorLectureResponse else { return }
                self.professorNameLabel.text = infoData.result.professorSimpleResponseDto.name
                self.professorLocationLabel.text = "교수실: \(infoData.result.professorSimpleResponseDto.location)"
                self.professorNumberLabel.text = "연락처: \(infoData.result.professorSimpleResponseDto.phoneNum)"
                self.professorEmailLabel.text = "이메일: \(infoData.result.professorSimpleResponseDto.email)"
                self.professorMajorLabel.text = "전 공: \(infoData.result.professorSimpleResponseDto.majorSub)"
                self.professorRoomLabel.text = "연구실: \(infoData.result.professorSimpleResponseDto.lab)"
                
                self.professorLectureList = infoData.result.list
                self.professorClassTableView.reloadData()
                
                // 실패할 경우에 분기처리는 아래와 같이 합니다.
            case .pathErr :
                print("잘못된 파라미터가 있습니다.")
            case .serverErr :
                print("서버에러가 발생했습니다.")
            default:
                print("networkFail")
            }
        }
    }
}


extension ProfessorInfoViewController: UITableViewDataSource{
    
    // 섹션의 갯수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //각 섹션 마다 cell row 숫자의 갯수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return professorLectureList?.count ?? 0
    }
    
    // 각 센션 마다 사용할 cell의 종류
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfessorClassTableViewCell", for: indexPath) as! ProfessorClassTableViewCell
        
        if let professorLectureData = professorLectureList?[indexPath.row] {
            cell.configure(professorLecture: professorLectureData)
        }
        
        return cell
    }
    
}

extension ProfessorInfoViewController: UITableViewDelegate {
    //cell이 클릭되었을때
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextViewController = ProfessorDetailClassViewController()
        
        navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    //Cell의 높이를 지정한다.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
