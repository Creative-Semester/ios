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
    
    private var checkBoxImage: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default // 선택되었을때 효과
        backgroundColor = .white
        setupLayout()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            // 선택 효과 지연 시간
            let delay: TimeInterval = 0.2
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.setSelected(false, animated: true)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(departmentPromises: DepartmentPromises) {
        
        checkBoxImage.image = departmentPromises.implementation ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        pledgeTitleLabel.text = departmentPromises.contents
    }
    
    func setupLayout() {
        contentView.addSubview(pledgeTitleLabel)
        contentView.addSubview(checkBoxImage)
        
        //[pledgeTitleLabel, checkBoxImage].forEach { addSubview($0)}
        
        pledgeTitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.centerY.equalTo(contentView.snp.centerY)
            make.leading.equalTo(contentView.snp.leading).offset(30)
        }
        
        checkBoxImage.snp.makeConstraints { make in
            make.centerY.equalTo(pledgeTitleLabel.snp.centerY)
            make.width.height.equalTo(30)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }
    }
}
