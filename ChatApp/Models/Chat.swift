//
//  Chat.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 01/09/25.
//

import Foundation
import FirebaseFirestoreSwift

struct Chat: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var lastMessage: String
    var timeStamp: Date
    var senderId: String
    var receiverId: String
}
