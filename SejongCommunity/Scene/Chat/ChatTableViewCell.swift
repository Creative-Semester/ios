//
//  ChatTableViewCell.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/08/21.
//

import UIKit
import SnapKit

class ChatTableViewCell: UITableViewCell {
    
    static let identifier = "ChatTableViewCell"
    
    private let profileView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(red: 1, green: 0.788, blue: 0.788, alpha: 1)
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    private let chatTitleLabel: UILabel = {
       let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "익명 1"
        label.numberOfLines = 1

        return label
    }()
    
    private let chatExpLabel: UILabel = {
       let label = UILabel()

        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "혹시 동양 고전독서 족보 20000만원 쿨거 부탁드..."
        label.numberOfLines = 1

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
    
    func setupLayout() {
        contentView.addSubview(profileView)
        profileView.snp.makeConstraints{ make in
            make.leading.equalTo(contentView.snp.leading).offset(30)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.height.equalTo(30)
        }
        
        contentView.addSubview(chatTitleLabel)
        chatTitleLabel.snp.makeConstraints{ make in
            make.leading.equalTo(profileView.snp.trailing).offset(10)
            make.top.equalTo(contentView.snp.top).offset(8)
        }
        
        contentView.addSubview(chatExpLabel)
        chatExpLabel.snp.makeConstraints{ make in
            make.leading.equalTo(profileView.snp.trailing).offset(10)
            make.top.equalTo(chatTitleLabel.snp.bottom).offset(5)
        }
    }
    
    func bindData(chatRoomList: ChatRoomDetailInfoResponseList) {
        chatTitleLabel.text = chatRoomList.boardName + "게시글의 채팅"
        chatExpLabel.text = chatRoomList.noteInfos?.contents ?? ""
    }
}
