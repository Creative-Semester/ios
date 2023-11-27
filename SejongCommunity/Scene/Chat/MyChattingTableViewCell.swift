//
//  MyChattingTableViewCell.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/09/30.
//

import UIKit
import SnapKit

class MyChattingTableViewCell: UITableViewCell {
    
    private let chattingBackView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(red: 1, green: 0.788, blue: 0.788, alpha: 0.5)
        view.layer.cornerRadius = 10
        view.layer.zPosition = 0
        
        return view
    }()
    
    private let chattingLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        label.layer.zPosition = 1
        
        return label
    }()
    
    private let dataLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .darkGray
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        contentView.addSubview(chattingLabel)
        chattingLabel.snp.makeConstraints{ make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).inset(12)
            make.width.lessThanOrEqualTo(300) // 원하는 가로 제한 크기 설정
        }
        
        contentView.addSubview(dataLabel)
        dataLabel.snp.makeConstraints{ make in
            make.bottom.equalTo(contentView.snp.bottom).offset(-3)
            make.trailing.equalTo(contentView.snp.trailing).offset(-5)
        }
    }
    
    func configure(with chatting: ChatNoteInfo) {
        chattingLabel.text = chatting.contents
        dataLabel.text = chatting.sendTime
        
        contentView.addSubview(chattingBackView)
        chattingBackView.snp.updateConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(3)
            make.leading.equalTo(chattingLabel.snp.leading).offset(-5)
            make.trailing.equalTo(chattingLabel.snp.trailing).offset(5)
            make.bottom.equalTo(dataLabel.snp.bottom).offset(-18)
        }
    }
}
