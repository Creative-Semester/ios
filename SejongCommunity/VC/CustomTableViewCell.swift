//
//  CustomTableViewCell.swift
//  SejongCommunity
//
//  Created by 정성윤 on 2023/07/31.
//

import Foundation
import UIKit
class CustomTableViewCell: UITableViewCell{
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
