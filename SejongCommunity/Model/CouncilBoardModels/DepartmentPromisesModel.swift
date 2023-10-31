//
//  DepartmentPromisesModel.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/10/08.
//

import Foundation

struct DepartmentPromisesResponse: Codable {
    let time: String
    let status: Int
    let code: String
    let message: String
    let result: [DepartmentPromises]
}

struct DepartmentPromises: Codable {
    let promiseId: Int
    let contents: String
    let implementation: Bool
}
