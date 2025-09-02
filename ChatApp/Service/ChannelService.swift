//
//  ChannelService.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 30/08/25.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

protocol ChannelServiceProtocol {
    func createOrGetChannel(senderId: String, recipientId: String) async throws -> String
    func getExistingChannels(senderId: String, recipientId: String) async throws -> String?
}

class ChannelService: ChannelServiceProtocol {
    
    private let db = Firestore.firestore()
    
    /// Create or get existing channel between two users
    func createOrGetChannel(senderId: String, recipientId: String) async throws -> String {
        let query = db.collection("channels")
            .whereField("participants", arrayContains: senderId)
        
        let snapshot = try await query.getDocuments(source: .server)
        
        let channels = try snapshot.documents.compactMap { try $0.data(as: Channel.self)}
        
        // check if a channel already exists between sender & recipient
        if let existing = channels.first(where: {$0.participants.contains(recipientId)}), let existingId = existing.id {
            debugPrint("Channel id exists: \(existingId)")
            return existingId
        }
        
        // create new channel
        let channel = Channel(
            participants: [senderId, recipientId],
            timestamp: Date(),
            lastMessage: nil,
            lastMessageAt: nil
        )
        
        let ref = try db.collection("channels").addDocument(from: channel)
        debugPrint("Channel id created: \(ref.documentID)")
        return ref.documentID
    }
    
    func getExistingChannels(senderId: String, recipientId: String) async throws -> String? {
        let query = db.collection("channels")
            .whereField("participants", arrayContains: senderId)
        
        let snapshot = try await query.getDocuments(source: .server)
        
        let channels = try snapshot.documents.compactMap { try $0.data(as: Channel.self)}
        
        // check if a channel already exists between sender & recipient
        if let existing = channels.first(where: {$0.participants.contains(recipientId)}), let existingId = existing.id {
            debugPrint("Channel id exists: \(existingId)")
            return existingId
        }
        return nil
    }
}

