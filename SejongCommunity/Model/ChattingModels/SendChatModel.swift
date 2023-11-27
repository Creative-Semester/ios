//
//  SendChatModel.swift
//  SejongCommunity
//
//  Created by 강민수 on 11/27/23.
//

import Foundation

struct SendChatModelResponse: Codable {
    let time: String
    let status: Int
    let code: String
    let message: String
    let result: SendChatRequest
}

struct SendChatRequest: Codable {
    let content, receiverStudentNum, senderStudentNum: String
}
