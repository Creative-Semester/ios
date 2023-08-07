//
//  TableViewCell.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/08/05.
//

import UIKit

class PledgeTableViewCell: UITableViewCell {
    
    private let pledgeTitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "지능기전 해지기전 학술제 개최"
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none // 선택되었을때 효과
        
        setupTableVieCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setupTableVieCell() {
        contentView.addSubview(pledgeTitleLabel)
        
        pledgeTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).offset(30)
        }
    }
}
