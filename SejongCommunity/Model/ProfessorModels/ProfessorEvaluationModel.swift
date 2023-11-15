//
//  ProfessorEvaluationModel.swift
//  SejongCommunity
//
//  Created by 강민수 on 11/13/23.
//

import Foundation

struct ProfessorEvaluationResponse: Codable {
    let time: String
    let status: Int
    let code, message: String
    let result: ProfessorEvaluation
}

struct ProfessorEvaluation: Codable {
    let totalPage, currentPage: Int
    let evaluationList: [EvaluationList]
}

struct EvaluationList: Codable {
    let evaluationId: Int
    let studentNum, text, createdTime: String
}
