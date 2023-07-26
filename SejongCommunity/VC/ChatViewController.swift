//
//  ChatViewController.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/07/23.
//

import UIKit
import SnapKit

class ChatViewController: UIViewController {

    private let voteBoardButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("안건 투표 게시판", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 1, green: 0.867, blue: 0.867, alpha: 1)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(voteBoardButtonTapped), for: .touchUpInside)

        
        return button
    }()
    
    private let pledgeButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("학생회 공약 보기", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 1, green: 0.867, blue: 0.867, alpha: 1)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(pledgeButtonTabbed), for: .touchUpInside)

        
        return button
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
        
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)//임시로 추가
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = "학생회 전체 공약 이행률"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let totalProgressPercentLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)//임시로 추가
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
        
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)//임시로 추가
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = "복지행사 공약 이행률"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let welfareProgressPercentLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)//임시로 추가
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
        
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)//임시로 추가
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = "문화행사 공약 이행률"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let cultureProgressPercentLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)//임시로 추가
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
        
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)//임시로 추가
        label.textColor = .darkGray
        label.textAlignment = .center
        label.text = "학술행사 공약 이행률"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let scholarshipProgressPercentLabel: UILabel = {
       let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)//임시로 추가
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        setupStudentCouncilView()
    }
    

    func setupStudentCouncilView() {
        view.addSubview(voteBoardButton)
        
        voteBoardButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(5)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(60)
        }
        
        view.addSubview(pledgeButton)
        
        pledgeButton.snp.makeConstraints { make in
            make.top.equalTo(voteBoardButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(60)
        }
        
        setupStackView()
    }
    
    func setupStackView() {
        view.addSubview(progressStackView)
        
        progressStackView.snp.makeConstraints { make in
            make.top.equalTo(pledgeButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
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

    @objc private func voteBoardButtonTapped() {
        // 버튼을 클릭했을 때 호출되는 함수

        let nextViewController = VoteBoardViewController() // 이동할 뷰 컨트롤러 생성

        // SecondViewController로 화면 전환을 수행
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
    @objc private func pledgeButtonTabbed() {
        // 버튼을 클릭했을 때 호출되는 함수

        let nextViewController = PledgeBoardViewController() // 이동할 뷰 컨트롤러 생성

        // SecondViewController로 화면 전환을 수행
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
