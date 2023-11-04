//
//  OfficeDetailsTableViewCell.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/08/08.
//

import UIKit

class OfficeDetailsTableViewCell: UITableViewCell {
    
    private let officeDetailTitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)//임시로 추가
        label.textColor = .black
        label.textAlignment = .left
        label.text = "지능기전 해지기전 학술제 사무내역"
        label.numberOfLines = 0
        
        return label
    }()
    
    private let officeDetailDateLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 10, weight: .medium)//임시로 추가
        label.textColor = .darkGray
        label.textAlignment = .left
        label.text = "23-07-24"
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default // 선택되었을때 효과
        
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
    
    func configure(officeDetailList: OfficeDetailList, time: String) {
        officeDetailTitleLabel.text = officeDetailList.title
        if let index = time.firstIndex(of: "T") {
            let dateSubstring = String(time[..<index])
            officeDetailDateLabel.text = dateSubstring
        }
    }
    
    func setupLayout() {
        contentView.addSubview(officeDetailTitleLabel)
        contentView.addSubview(officeDetailDateLabel)
        
        //[pledgeTitleLabel, checkBoxImage].forEach { addSubview($0)}
        
        officeDetailTitleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY).offset(-8)
            make.leading.equalTo(contentView.snp.leading).offset(30)
        }
        
        officeDetailDateLabel.snp.makeConstraints { make in
            make.top.equalTo(officeDetailTitleLabel.snp.bottom).offset(4)
            make.leading.equalTo(contentView.snp.leading).offset(30)
        }
    }
}
