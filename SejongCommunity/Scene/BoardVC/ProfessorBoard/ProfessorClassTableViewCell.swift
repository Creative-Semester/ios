//
//  ProfessorClassTableViewCell.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/09/11.
//

import UIKit
import SnapKit

class ProfessorClassTableViewCell: UITableViewCell {
    
    private let classTitleLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "신호 및 시스템"
        label.numberOfLines = 0
        
        return label
    }()
    
    private let classExpLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "2학년, 전선, 3학점"
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .default // 선택되었을때 효과
        backgroundColor = .white
        
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    func setupLayout() {
        
        contentView.addSubview(classTitleLabel)
        classTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(contentView.snp.top).offset(12)
            make.leading.equalTo(contentView.snp.leading).offset(12)
        }
        
        contentView.addSubview(classExpLabel)
        classExpLabel.snp.makeConstraints{ make in
            make.top.equalTo(classTitleLabel.snp.bottom).offset(6)
            make.leading.equalTo(contentView.snp.leading).offset(12)
        }
    }
    
    func configure(professorLecture: ProfessorLecture) {
        classTitleLabel.text = professorLecture.title
        let classification: String = professorLecture.classification
        let grade: String = professorLecture.grade
        let score: String = professorLecture.score
        classExpLabel.text = "\(grade)학년 \(classification) \(score)학점"
    }
}
