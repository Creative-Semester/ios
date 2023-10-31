//
//  DepartmentModel.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/10/08.
//

import Foundation

struct DepartmentResponse: Codable {
    let time: String
    let status: Int
    let code: String
    let message: String
    let result: [DepartmentInfo]
}

struct DepartmentInfo: Codable {
    let id: Int
    let name: String
}
