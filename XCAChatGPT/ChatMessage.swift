//
//  ChatMessage.swift
//  XCAChatGPT
//
//  Created by Khanh Nguyen on 03/05/2023.
//

import Foundation

struct ChatMessage {
    let id: String
    let content: String
    let dateCreated: Date
    let gender: MessageGender
}

enum MessageGender {
    case me
    case gpt
}

extension ChatMessage {
    static let simpleMessage = [
        ChatMessage(id: UUID().uuidString, content: "simple message from khanh", dateCreated: Date(), gender: .me),
        ChatMessage(id: UUID().uuidString, content: "simple message from khanh", dateCreated: Date(), gender: .gpt),
        ChatMessage(id: UUID().uuidString, content: "simple message from khanh", dateCreated: Date(), gender: .me),
        ChatMessage(id: UUID().uuidString, content: "simple message from khanh", dateCreated: Date(), gender: .gpt)
    ]
}
