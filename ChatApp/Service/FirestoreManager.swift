//
//  FirestoreManager.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 28/08/25.
//

import Foundation
import FirebaseFirestore

protocol FirestoreServiceProtocol: AnyObject {
    func fetchCollection<T: Decodable>(path: String) async throws -> [T]
    func updateCollection(path: String, user: FirebaseUser) async throws
    func fetchCurrentUser<T: Decodable>(path: String, id: String) async throws -> T
}

final class FirestoreService: FirestoreServiceProtocol {
    
    private let db = Firestore.firestore()
    
    func fetchCollection<T: Decodable>(path: String) async throws -> [T] {
        let snapshot = try await db.collection(path)
            .getDocuments(source: .server)
        return try snapshot.documents.compactMap { doc in
            try doc.data(as: T.self)
        }
    }
    
    func fetchCurrentUser<T: Decodable>(path: String, id: String) async throws -> T {
        let snapshot = try await db.collection(path)
            .document(id)
            .getDocument()
        return try snapshot.data(as: T.self)
    }
    
    func updateCollection(path: String, user: FirebaseUser) async throws {
        guard let id = user.id?.description else { return }
        let data = try JSONEncoder().encode(user)
        let json = try JSONSerialization.jsonObject(with: data) as! [String : Any]
        try await db.collection(path).document(id).setData(json)
    }
    
    deinit {
        print("🔻 FirestoreManager deinit")
    }
}

