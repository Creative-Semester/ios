//
//  ProfessorPostReviewMedel.swift
//  SejongCommunity
//
//  Created by 강민수 on 11/4/23.
//

import Foundation

struct ProfessorPostReviewResponse: Codable {
    let time: String
    let status: Int
    let code, message: String
}
