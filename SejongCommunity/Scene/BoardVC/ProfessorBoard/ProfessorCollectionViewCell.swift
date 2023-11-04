//
//  ProfessorCollectionViewCell.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/08/31.
//

import UIKit
import Kingfisher
import SnapKit

class ProfessorCollectionViewCell: UICollectionViewCell {
    
    private let professorImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "professor")
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .gray
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        
        return imageView
    }()
    
    private let professorNameLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "김세원"
        label.numberOfLines = 1
        
        return label
    }()
    
    private let professorExpLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = """
        Autonomous Vessel Navigation Algorithm
        Optimal Routing Algorithm 등을 연구하며 자율운항에 연구를 합니다.
        """
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor.darkGray.cgColor // 그림자 색깔
        self.layer.shadowOpacity = 1 // 그림자 투명도
        self.layer.shadowRadius = 5 // 그림자 크기
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.cornerRadius = 10
        
        setupLayout()
    }
    
    func setupLayout() {
        contentView.addSubview(professorImageView)
        professorImageView.snp.makeConstraints{ make in
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.height.equalTo(110)
        }
        
        contentView.addSubview(professorNameLabel)
        professorNameLabel.snp.makeConstraints{ make in
            make.top.equalTo(professorImageView.snp.top)
            make.leading.equalTo(professorImageView.snp.trailing).offset(20)
        }
        
        contentView.addSubview(professorExpLabel)
        professorExpLabel.snp.makeConstraints{ make in
            make.top.equalTo(professorNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(professorImageView.snp.trailing).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
            make.bottom.lessThanOrEqualTo(contentView.snp.bottom).offset(-10)
        }
    }
    
    func configure(professorInfo: ProfessorInfo) {
        let url = URL(string: professorInfo.image)
        professorImageView.kf.setImage(with: url)
        professorNameLabel.text = professorInfo.name
        professorExpLabel.text = professorInfo.intro
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
