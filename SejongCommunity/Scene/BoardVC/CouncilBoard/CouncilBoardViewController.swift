//
//  CouncilBoardViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/07/25.
//

import Foundation
import UIKit
import SnapKit

class CouncilBoardViewController : UIViewController {
    
    private let studentCouncilImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "studentCouncil")
        
        return imageView
    }()
    
    private let studentCouncilNameLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "AI로봇공학과"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let studentCouncilExpLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)//임시로 추가
        label.textColor = .darkGray
        label.textAlignment = .left
        label.text = "제 7대 학생회\nRU:RI - 하나되어 울리는 두드림입니다."
        label.numberOfLines = 2
        
        return label
    }()
    
    
    private let officeDetailButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("사무내역보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.setTitleColor(.darkGray, for: .normal)

        return button
    }()
    
    private let officeDetailRightErrow: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .darkGray
        
        return imageView
    }()
    
    private let lineView: UIView = {
       let view = UIView()
        
        view.backgroundColor = .lightGray
        
        return view
    }()
    
    private let pledgeTitleLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "공약 이행도"
        label.numberOfLines = 1
        
        return label
    }()
    
    
    private let pledgeButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("전체보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        button.setTitleColor(.darkGray, for: .normal)
        
        return button
    }()
    
    private let pledgeRightErrow: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .darkGray
        
        return imageView
    }()
    
    
    private let progressStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        stackView.backgroundColor = .white
        
        return stackView
    }()
    
    private let totalProgressView: UIView = {
       let view = UIView()
        
        view.backgroundColor = .white
        
        return view
    }()
    
    private let totalProgressTitleLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)//임시로 추가
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = "학생회 전체 공약 이행률"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let totalProgressPercentLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)//임시로 추가
        label.textColor = .black
        label.textAlignment = .center
        label.text = "47%"
        label.numberOfLines = 1
        
        return label
    }()
    
    
    private let totalProgressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        
        progressView.progressTintColor = UIColor(red: 1, green: 0.867, blue: 0.867, alpha: 1)
        progressView.trackTintColor = UIColor.lightGray
        progressView.progress = 0.4
        progressView.clipsToBounds = true
        
        return progressView
    }()
    
    private let welfareProgressView: UIView = {
       let view = UIView()
        
        view.backgroundColor = .white
        
        return view
    }()
    
    private let welfareProgressTitleLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)//임시로 추가
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = "복지행사 공약 이행률"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let welfareProgressPercentLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)//임시로 추가
        label.textColor = .black
        label.textAlignment = .center
        label.text = "47%"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let welfareProgressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        
        progressView.progressTintColor = UIColor(red: 1, green: 0.867, blue: 0.867, alpha: 1)
        progressView.trackTintColor = UIColor.lightGray
        progressView.progress = 0.4
        progressView.clipsToBounds = true
        
        return progressView
    }()
    
    private let cultureProgressView: UIView = {
       let view = UIView()
        
        view.backgroundColor = .white
        
        return view
    }()
    
    private let cultureProgressTitleLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)//임시로 추가
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = "문화행사 공약 이행률"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let cultureProgressPercentLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)//임시로 추가
        label.textColor = .black
        label.textAlignment = .center
        label.text = "47%"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let cultureProgressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        
        progressView.progressTintColor = UIColor(red: 1, green: 0.867, blue: 0.867, alpha: 1)
        progressView.trackTintColor = UIColor.lightGray
        progressView.progress = 0.4
        progressView.clipsToBounds = true
        
        return progressView
    }()
    
    private let scholarshipProgressView: UIView = {
       let view = UIView()
        
        view.backgroundColor = .white
        
        return view
    }()
    
    private let scholarshipProgressTitleLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)//임시로 추가
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = "학술행사 공약 이행률"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let scholarshipProgressPercentLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 13, weight: .bold)//임시로 추가
        label.textColor = .black
        label.textAlignment = .center
        label.text = "47%"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let scholarshipProgressBar: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .bar)
        
        progressView.progressTintColor = UIColor(red: 1, green: 0.867, blue: 0.867, alpha: 1)
        progressView.trackTintColor = UIColor.lightGray
        progressView.progress = 0.4
        progressView.clipsToBounds = true
        
        return progressView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "학생회"
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .red
        self.view.backgroundColor = .white
        
        pledgeButton.addTarget(self, action: #selector(pledgeButtonTabbed), for: .touchUpInside)
        officeDetailButton.addTarget(self, action: #selector(officeDetailButtonTapped), for: .touchUpInside)

        setupStudentCouncilView()
    }
    
}

extension CouncilBoardViewController {
    
    @objc private func officeDetailButtonTapped() {
        // 버튼을 클릭했을 때 호출되는 함수

        let nextViewController = OfficeDetailsViewController() // 이동할 뷰 컨트롤러 생성

        // SecondViewController로 화면 전환을 수행
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc private func pledgeButtonTabbed() {
        // 버튼을 클릭했을 때 호출되는 함수

        let nextViewController = PledgeBoardViewController() // 이동할 뷰 컨트롤러 생성

        // SecondViewController로 화면 전환을 수행
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    func setupStudentCouncilView() {
        
        view.addSubview(studentCouncilImageView)
        
        studentCouncilImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(170)
        }
        
        view.addSubview(studentCouncilNameLabel)
        
        studentCouncilNameLabel.snp.makeConstraints { make in
            make.top.equalTo(studentCouncilImageView.snp.bottom).offset(15)
            make.leading.equalTo(view.snp.leading).offset(15)
        }
        
        view.addSubview(studentCouncilExpLabel)
        
        studentCouncilExpLabel.snp.makeConstraints { make in
            make.top.equalTo(studentCouncilNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.snp.leading).offset(15)
        }
        
        view.addSubview(officeDetailButton)
        
        officeDetailButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing).offset(-30)
            make.bottom.equalTo(studentCouncilExpLabel.snp.bottom).offset(6.5)
        }
        
        view.addSubview(officeDetailRightErrow)
        
        officeDetailRightErrow.snp.makeConstraints { make in
            make.leading.equalTo(officeDetailButton.snp.trailing)
            make.centerY.equalTo(officeDetailButton.snp.centerY)
            make.height.width.equalTo(13)
        }
        
        view.addSubview(lineView)
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(officeDetailButton.snp.bottom).offset(10)
            make.leading.equalTo(view.snp.leading).offset(15)
            make.trailing.equalTo(view.snp.trailing).offset(-15)
            make.height.equalTo(1)
        }
        
        view.addSubview(pledgeTitleLabel)
        
        pledgeTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.leading.equalTo(view.snp.leading).offset(15)
        }
        
        view.addSubview(pledgeButton)
        
        pledgeButton.snp.makeConstraints { make in
            make.bottom.equalTo(pledgeTitleLabel.snp.bottom)
            make.trailing.equalTo(view.snp.trailing).offset(-30)
        }
        
        view.addSubview(pledgeRightErrow)
        
        pledgeRightErrow.snp.makeConstraints { make in
            make.leading.equalTo(pledgeButton.snp.trailing)
            make.centerY.equalTo(pledgeButton.snp.centerY)
            make.height.width.equalTo(13)
        }
        
        setupStackView()
    }
    
    func setupStackView() {
        view.addSubview(progressStackView)
        
        progressStackView.snp.makeConstraints { make in
            make.top.equalTo(pledgeTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        progressStackView.addArrangedSubview(totalProgressView)
        progressStackView.addArrangedSubview(welfareProgressView)
        progressStackView.addArrangedSubview(cultureProgressView)
        progressStackView.addArrangedSubview(scholarshipProgressView)
        
        //학생회 전체 공약 이행률
        totalProgressView.addSubview(totalProgressTitleLabel)
        
        totalProgressTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(totalProgressView.snp.centerY).offset(-20)
            make.leading.equalTo(totalProgressView.snp.leading).offset(10)
        }
        
        totalProgressView.addSubview(totalProgressPercentLabel)
        
        totalProgressPercentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(totalProgressTitleLabel.snp.centerY)
            make.trailing.equalTo(totalProgressView.snp.trailing).offset(-10)
        }
        
        totalProgressView.addSubview(totalProgressBar)
        
        totalProgressBar.snp.makeConstraints { make in
            make.centerY.equalTo(totalProgressView.snp.centerY).offset(10)
            make.leading.equalTo(totalProgressView.snp.leading).offset(10)
            make.trailing.equalTo(totalProgressView.snp.trailing).offset(-10)
            make.height.equalTo(15)
        }
        //복지행사 공약 이행률
        
        welfareProgressView.addSubview(welfareProgressTitleLabel)
        
        welfareProgressTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(welfareProgressView.snp.centerY).offset(-20)
            make.leading.equalTo(welfareProgressView.snp.leading).offset(10)
        }
        
        welfareProgressView.addSubview(welfareProgressPercentLabel)
        
        welfareProgressPercentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(welfareProgressTitleLabel.snp.centerY)
            make.trailing.equalTo(welfareProgressView.snp.trailing).offset(-10)
        }
        
        welfareProgressView.addSubview(welfareProgressBar)
        
        welfareProgressBar.snp.makeConstraints { make in
            make.centerY.equalTo(welfareProgressView.snp.centerY).offset(10)
            make.leading.equalTo(welfareProgressView.snp.leading).offset(10)
            make.trailing.equalTo(welfareProgressView.snp.trailing).offset(-10)
            make.height.equalTo(15)
        }
        
        //문화행사 공약 이행률
        
        cultureProgressView.addSubview(cultureProgressTitleLabel)
        
        cultureProgressTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(cultureProgressView.snp.centerY).offset(-20)
            make.leading.equalTo(cultureProgressView.snp.leading).offset(10)
        }
        
        cultureProgressView.addSubview(cultureProgressPercentLabel)
        
        cultureProgressPercentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(cultureProgressTitleLabel.snp.centerY)
            make.trailing.equalTo(cultureProgressView.snp.trailing).offset(-10)
        }
        
        cultureProgressView.addSubview(cultureProgressBar)
        
        cultureProgressBar.snp.makeConstraints { make in
            make.centerY.equalTo(cultureProgressView.snp.centerY).offset(10)
            make.leading.equalTo(cultureProgressView.snp.leading).offset(10)
            make.trailing.equalTo(cultureProgressView.snp.trailing).offset(-10)
            make.height.equalTo(15)
        }
        
        //학술행사 공약 이행률
        
        scholarshipProgressView.addSubview(scholarshipProgressTitleLabel)
        
        scholarshipProgressTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(scholarshipProgressView.snp.centerY).offset(-20)
            make.leading.equalTo(scholarshipProgressView.snp.leading).offset(10)
        }
        
        scholarshipProgressView.addSubview(scholarshipProgressPercentLabel)
        
        scholarshipProgressPercentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(scholarshipProgressTitleLabel.snp.centerY)
            make.trailing.equalTo(scholarshipProgressView.snp.trailing).offset(-10)
        }
        
        scholarshipProgressView.addSubview(scholarshipProgressBar)
        
        scholarshipProgressBar.snp.makeConstraints { make in
            make.centerY.equalTo(scholarshipProgressView.snp.centerY).offset(10)
            make.leading.equalTo(scholarshipProgressView.snp.leading).offset(10)
            make.trailing.equalTo(scholarshipProgressView.snp.trailing).offset(-10)
            make.height.equalTo(15)
        }
    }
}
