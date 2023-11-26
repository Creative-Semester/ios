//
//  ChatGetRoomModel.swift
//  SejongCommunity
//
//  Created by 강민수 on 11/26/23.
//

import Foundation

struct ChatGetRoomResponse: Codable {
    let time: String
    let status: Int
    let code: String
    let message: String
    let result: ChatGetRoomnfo
}

struct ChatGetRoomnfo: Codable {
    let roomId: Int
    let senderStudentNum, receiverStudentNum: String

}


