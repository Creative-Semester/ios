//
//  OfficeDetailPostModel.swift
//  SejongCommunity
//
//  Created by 강민수 on 11/5/23.
//

import Foundation

struct OfficeDetailPostResponse: Codable {
    let time: String
    let status: Int
    let code: String
    let message: String
}

struct OfficeDetailPostMenu {
    var affairName: String
    var affairUrl: String
    var restMoney: String
    var title: String
    var usedMoney: String
    
    init(affairName: String, affairUrl: String, restMoney: String, title: String, usedMoney: String) {
        self.affairName = affairName
        self.affairUrl = affairUrl
        self.restMoney = restMoney
        self.title = title
        self.usedMoney = usedMoney
    }
}
