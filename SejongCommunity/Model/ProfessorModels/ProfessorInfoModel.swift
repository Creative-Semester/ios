//
//  ProfessorInfoModel.swift
//  SejongCommunity
//
//  Created by 강민수 on 11/4/23.
//

import Foundation

struct ProfessorInfoResponse: Codable {
    let time: String
    let status: Int
    let code, message: String
    let result: ProfessorInfoResult
}

struct ProfessorInfoResult: Codable {
    let totalPage, currentPage: Int
    let list: [ProfessorInfo]
}

struct ProfessorInfo: Codable {
    let professorId: Int
    let name, intro: String
    let file: ImageFile
}

struct ImageFile: Codable {
    let imageName, imageUrl: String
}
