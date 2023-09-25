//
//  PledgeBoardMenuCollectionViewCell.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/09/25.
//

import UIKit

class PledgeBoardMenuCollectionViewCell: UICollectionViewCell {
    
    private let menuLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)//임시로 추가
        label.textColor = .black
        label.textAlignment = .center
        label.text = ""
        label.numberOfLines = 1
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 1, green: 0.788, blue: 0.788, alpha: 0.3)
        self.layer.cornerRadius = 15
        self.clipsToBounds = true // 배경색이 cornerRadius 내에서만 그려지도록 설정
        
        setupLayout()
    }
    
    func setupLayout() {
        contentView.addSubview(menuLabel)
        menuLabel.snp.makeConstraints{ make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    func configure(with title: String) {
        menuLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
