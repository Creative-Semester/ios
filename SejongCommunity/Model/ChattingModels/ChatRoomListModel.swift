//
//  ChatRoomListModel.swift
//  SejongCommunity
//
//  Created by 강민수 on 11/27/23.
//

import Foundation

struct ChatRoomListModelResponse: Codable {
    let time: String
    let status: Int
    let code: String
    let message: String
    let result: ChatGetRoomListInfo
}

struct ChatGetRoomListInfo: Codable {
    let chatRoomDetailInfoResponseList: [ChatRoomDetailInfoResponseList]
    let currentPage, totalPages: Int
}

struct ChatRoomDetailInfoResponseList: Codable {
    let boardName: String
    let noteInfos: ChatNoteInfo?
    let receiverStudentNum: String
    let roomId: Int
    let senderStudentNum: String
}
