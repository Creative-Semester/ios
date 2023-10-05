
//
//  HeaderViewCell.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/10/05.
//

import Foundation
import UIKit
class HeaderViewCell: UITableViewCell {
    // HeaderViewCell에 포함될 디테일 뷰
    let detailView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 디테일 뷰와 다른 UI 요소들을 HeaderViewCell에 추가
        addSubview(detailView)
        detailView.addSubview(commentLabel)
        
        // 오토레이아웃 설정
        detailView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(200) // 디테일 뷰의 높이 설정
        }
        
        commentLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(0)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(40)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
