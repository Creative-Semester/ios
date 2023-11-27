//
//  ChatPostRoomModel.swift
//  SejongCommunity
//
//  Created by 강민수 on 11/26/23.
//

import Foundation

struct ChatPostRoomResponse: Codable {
    let time: String
    let status: Int
    let code: String
    let message: String
    let result: ChatPostRoomInfo
}

struct ChatPostRoomInfo: Codable {
    let roomId: Int
}
