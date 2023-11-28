//
//  OfficeDetailListModel.swift
//  SejongCommunity
//
//  Created by 강민수 on 11/4/23.
//

import Foundation

struct OfficeDetailListResponse: Codable {
    let time: String
    let status: Int
    let code: String
    let message: String
    let result: [OfficeDetailList]
}

struct OfficeDetailList: Codable {
    let affairId: Int
    let restMoney, usedMoney, title, createdTime: String
    let fileInfo: FileInfo
}

struct FileInfo: Codable {
    let fileName: String
    let fileUrl: String
}
