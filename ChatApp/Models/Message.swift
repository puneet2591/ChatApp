//
//  Message.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 26/08/25.
//

import Foundation
import FirebaseFirestoreSwift

struct Message: Identifiable, Codable {
    @DocumentID var id: String?
    var email: String
    var senderId: String
    var receiverId: String
    var text: String
    var timestamp: Date
}
