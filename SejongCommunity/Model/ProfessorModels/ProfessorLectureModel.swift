//
//  ProfessorLectureModel.swift
//  SejongCommunity
//
//  Created by 강민수 on 11/4/23.
//

import Foundation

struct ProfessorLectureResponse: Codable {
    let time: String
    let status: Int
    let code, message: String
    let result: ProfessorLectureResult
}

struct ProfessorLectureResult: Codable {
    let totalPage, currentPage: Int
    let list: [ProfessorLecture]
    let professorSimpleResponseDto: ProfessorLectureInfo
}

struct ProfessorLecture: Codable {
    let courseId: Int
    let title, classification, grade, score: String
}

struct ProfessorLectureInfo: Codable {
    let name, image, location, phoneNum: String
    let email, majorSub, lab: String
}
