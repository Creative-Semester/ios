//
//  CustomCommentTableViewCell.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/10/07.
//

import Foundation
import UIKit
import SnapKit
class CustomCommentTableViewCell: UITableViewCell{
    // 제목, 내용, 이미지
    var commentLabel = UILabel()
    // 날짜, 시간
    var DayLabel = UILabel()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        // commentLabel 설정
        commentLabel.numberOfLines = 0 //여러 줄의 텍스트를 표시하기 위해 설정
        commentLabel.font = UIFont.systemFont(ofSize: 15)
//        contentView.addSubview(commentLabel)
        
        // DayLabel 설정
        DayLabel.font = UIFont.boldSystemFont(ofSize: 12)
        DayLabel.textColor = .gray
        
        // stack으로 오토레이아웃 설정
        let AllStackView = UIStackView()
        AllStackView.axis = .horizontal
        AllStackView.distribution = .fill
        AllStackView.spacing = 10
        AllStackView.alignment = .fill
        // 제목, 내용, 시간에 대해 넣을 뷰
        let totalView = UIView()
        totalView.backgroundColor = .white
        totalView.addSubview(commentLabel)
        totalView.addSubview(DayLabel)
        AllStackView.addArrangedSubview(totalView)
        contentView.addSubview(AllStackView)
        
        //SnapKit으로 오토레이아웃 설정
        AllStackView.snp.makeConstraints{ (make) in
            make.top.bottom.leading.equalToSuperview().inset(0)
            make.trailing.equalToSuperview().offset(-20)
        }
        totalView.snp.makeConstraints{ (make) in
            make.top.bottom.leading.trailing.equalToSuperview().inset(0)
        }
        commentLabel.numberOfLines = 0 // 0으로 설정하여 여러 줄 표시를 허용
        commentLabel.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(5)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.lessThanOrEqualToSuperview().offset(-30) // bottom 제약을 "작거나 같음"으로 설정
        }
        DayLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(commentLabel.snp.bottom).offset(10)
//            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(AllStackView.snp.width).dividedBy(1.5)
            make.leading.equalToSuperview().offset(20)
        }
    }
}
