//
//  ProfessorReviewTableViewCell.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/09/18.
//

import UIKit
import SnapKit

protocol ProfessorReviewTableViewCellDelegate: AnyObject {
    func buttonTappedWithEvaluationId(_ evaluationId: Int, task: String)
}

class ProfessorReviewTableViewCell: UITableViewCell {

    private var evaluationId: Int?
    private var task: String?
    weak var delegate: ProfessorReviewTableViewCellDelegate?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "익명 1"
        label.numberOfLines = 0
        
        return label
    }()
    
    private let reviewLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text =
        """
        요즘 이것만큼 좋은 강의가 있나?
        이것은 혁명이다.
        조선 혁명당입니다만 김씨일가 화이팅
        """
        label.numberOfLines = 0
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "23.09.18 19:39"
        label.numberOfLines = 0
        
        return label
    }()
    
    private let reportButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(systemName: "light.beacon.min"), for: .normal)
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        reportButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        setupLayout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // 셀이 재사용될 때 버튼의 이미지 초기화
        reportButton.setImage(nil, for: .normal)
        reportButton.tintColor = .black
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        guard let evaluationId = evaluationId else { return }
        guard let task = task else { return }
        delegate?.buttonTappedWithEvaluationId(evaluationId, task: task)
    }
    
    func setupLayout() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints{ make in
            make.top.equalTo(contentView.snp.top).offset(12)
            make.leading.equalTo(contentView.snp.leading).offset(12)
        }
        
        contentView.addSubview(reviewLabel)
        reviewLabel.snp.makeConstraints{ make in
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.leading.equalTo(contentView.snp.leading).offset(12)
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints{ make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(12)
            
        }
        
        contentView.addSubview(reportButton)
        reportButton.snp.makeConstraints{ make in
            make.trailing.equalTo(contentView.snp.trailing).inset(20)
            make.height.width.equalTo(14)
            make.centerY.equalTo(nameLabel.snp.centerY)
        }
        
    }
    
    func configure(evaluationList: EvaluationList) {
        evaluationId = evaluationList.evaluationId
        nameLabel.text = "익명\(evaluationList.evaluationId)"
        reviewLabel.text = evaluationList.text
        
        let time = evaluationList.createdTime
        if let index = time.firstIndex(of: "T") {
            let dateSubstring = String(time[..<index])
            dateLabel.text = dateSubstring
        }
        if let userName = UserDefaults.standard.string(forKey: "userName") {
            if userName == evaluationList.name {
                reportButton.setImage(UIImage(systemName: "trash"), for: .normal)
                reportButton.tintColor = .systemBlue
                task = "remove"
            } else {
                reportButton.setImage(UIImage(systemName: "light.beacon.min"), for: .normal)
                reportButton.tintColor = .systemRed
                task = "report"
            }
        }
    }

}
