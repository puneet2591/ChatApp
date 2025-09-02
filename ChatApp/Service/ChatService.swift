//
//  ChatService.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 28/08/25.
//

import Foundation
import FirebaseFirestore

protocol ChatServiceProtocol: AnyObject {
    func addMessageListener(channelId: String, listener: @escaping (QuerySnapshot?, Error?) -> Void) throws -> ListenerRegistration
    func addLastMessageListener(channelId: String, listener: @escaping (DocumentSnapshot?, Error?) -> Void) throws -> ListenerRegistration
    func sendMessage(channelId: String, name: String, message: Message) async throws
    func removeListener(_ listener: ListenerRegistration)
    func fetchMessages(channelId: String) async throws -> [Message]
}

final class ChatService: ChatServiceProtocol {
    
    private let db = Firestore.firestore()
    
    func fetchMessages(channelId: String) async throws -> [Message] {
        let snapshot = try await db.collection("channels")
            .document(channelId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .getDocuments()
        
        return snapshot.documents.compactMap { try? $0.data(as: Message.self) }
    }
    
    func addMessageListener(channelId: String, listener: @escaping (QuerySnapshot?, Error?) -> Void) throws -> ListenerRegistration {
        
        // Query messages where participants array contains currentUserId,
        // then filter client-side for the specific pair, or build two-direction query using OR (Firestore now supports inQuery?).
        // Simpler reliable approach: query messages where participants array contains currentUserId, ordered by timestamp.
        return db.collection("channels")
            .document(channelId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener(listener)
    }
    
    func addLastMessageListener(channelId: String, listener: @escaping (DocumentSnapshot?, Error?) -> Void) throws -> ListenerRegistration {
        return db.collection("channels")
            .document(channelId)
            .addSnapshotListener(listener)
    }
    
    func sendMessage(channelId: String, name: String, message: Message) async throws {
        
        // Add message to subcollection
        _ = try db.collection("channels")
            .document(channelId)
            .collection("messages")
            .addDocument(from: message)
        
        let lastMessage = Chat(id: channelId, name: name, email: message.email, lastMessage: message.text, timeStamp: message.timestamp, senderId: message.senderId, receiverId: message.receiverId)
        // Update channel with last message info
        try db.collection("chats")
            .document(channelId)
            .setData(from: lastMessage)
    }
    
    func removeListener(_ listener: ListenerRegistration) {
        listener.remove()
    }
    
    deinit {
        print("🔻 ChatService deinit")
    }
}
