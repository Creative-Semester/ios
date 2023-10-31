//
//  PromisesPercentageModel.swift
//  SejongCommunity
//
//  Created by 강민수 on 2023/10/08.
//

import Foundation

struct PromisesPercentageResponse: Codable {
    let time: String
    let status: Int
    let code: String
    let message: String
    let result: PromisesPercentage
}

struct PromisesPercentage: Codable {
    let deptPromiseRate: [DeptPromiseRate]
    let totalPercent: Double
}

struct DeptPromiseRate: Codable {
    let departmentName: String
    let percent: Double
}

