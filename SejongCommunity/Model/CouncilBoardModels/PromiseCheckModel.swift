//
//  PromiseCheckModel.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/10/09.
//

import Foundation

struct PromiseCheckResponse: Codable {
    let time: String
    let status: Int
    let code, message: String
}
