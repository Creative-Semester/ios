//
//  OfficeFileUploadModel.swift
//  SejongCommunity
//
//  Created by 강민수 on 11/5/23.
//

import Foundation

struct OfficeFileUploadResponse: Codable {
    let time: String
    let status: Int
    let code: String
    let message: String
    let result: OfficeFileUpload
}

struct OfficeFileUpload: Codable {
    let imageName, imageUrl: String
}
