//
//  OfficeFileDeleteResponse.swift
//  SejongCommunity
//
//  Created by 강민수 on 11/5/23.
//

import Foundation

struct OfficeFileDeleteResponse: Codable {
    let time: String
    let status: Int
    let code: String
    let message: String
    let result: OfficeFileDelete?
}

struct OfficeFileDelete: Codable {
    let imageName, imageUrl: String
}
