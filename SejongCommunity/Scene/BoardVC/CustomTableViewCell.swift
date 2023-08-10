//
//  CustomTableViewCell.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/07/31.
//

import Foundation
import UIKit
import SnapKit
class CustomTableViewCell: UITableViewCell{
    var titleLabel = UILabel()
    var commentLabel = UILabel()
    var postImageView = UIImageView()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        //titleLabel 설정
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
//        contentView.addSubview(titleLabel)
        
        // commentLabel 설정
        commentLabel.numberOfLines = 0 //여러 줄의 텍스트를 표시하기 위해 설정
//        contentView.addSubview(commentLabel)
        
         
        // stack으로 오토레이아웃 설정
        let AllStackView = UIStackView()
        AllStackView.axis = .horizontal
        AllStackView.distribution = .fill
        AllStackView.spacing = 20
        AllStackView.alignment = .fill
        let StackView = UIStackView()
        StackView.axis = .vertical
        StackView.distribution = .fill
        StackView.spacing = 20
        StackView.alignment = .fill
        StackView.addArrangedSubview(titleLabel)
        StackView.addArrangedSubview(commentLabel)
        AllStackView.addArrangedSubview(StackView)
        
        //이미지 설정
        postImageView.tintColor = .white
        AllStackView.addArrangedSubview(postImageView)
        contentView.addSubview(AllStackView)
        
        //SnapKit으로 오토레이아웃 설정
        AllStackView.snp.makeConstraints{ (make) in
            make.top.bottom.leading.equalToSuperview().inset(0)
            make.trailing.equalToSuperview().offset(-20)
        }
        StackView.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalToSuperview().inset(0)
        }
        postImageView.snp.makeConstraints{ (make) in
            make.top.bottom.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().offset(0)
            make.width.equalTo(AllStackView.snp.width).dividedBy(3)
        }
        titleLabel.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset((20))
            make.width.equalTo(AllStackView.snp.width).dividedBy(2)
            make.height.equalTo(20)
        }
        commentLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset((20))
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(AllStackView.snp.width).dividedBy(2)
            make.height.equalTo(20)
        }
    }
}
