//
//  CouncilInfoModel.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/10/06.
//

import Foundation

struct CouncilInfoResponse: Codable {
    let time: String
    let status: Int
    let code: String
    let message: String
    let result: CouncilInfo
}

struct CouncilInfo: Codable {
    let name, introduce: String
    let number: Int
}
