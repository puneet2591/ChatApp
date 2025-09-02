//
//  Channel.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 30/08/25.
//

import Foundation
import FirebaseFirestoreSwift

struct Channel: Codable {
    @DocumentID var id: String?
    var participants: [String]   // userIds of participants
    var timestamp: Date
    var lastMessage: String?
    var lastMessageAt: Date?
}
