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
        contentView.addSubview(titleLabel)
        
        // commentLabel 설정
        commentLabel.numberOfLines = 0 //여러 줄의 텍스트를 표시하기 위해 설정
        contentView.addSubview(commentLabel)
        
        titleLabel.snp.makeConstraints{ (make) in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset((20))
            make.width.equalTo(150)
            make.height.equalTo(20)
        }
        commentLabel.snp.makeConstraints{ (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset((20))
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(300)
            make.height.equalTo(20)
        }
    }
}
