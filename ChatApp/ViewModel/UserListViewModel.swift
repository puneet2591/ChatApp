//
//  UserListViewModel.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 26/08/25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

//@MainActor
//class UserListViewModel: ObservableObject {
//    @EnvironmentObject private var obj: FirebaseAuthViewModel
//    @Published var users: [FirebaseUser] = []
//    
//    //private let db = FirebaseManager.shared.firestore
//    private var listner: ListenerRegistration?
////    private var task: Task<Void, Never>?   // keep reference to async task
//    
//    deinit {
//        debugPrint("User list view model deallocated")
//    }
//    
////    func fetchUsers() {
////        self.users = [
////
////            FirebaseUser(email: "doom@gmail.com", name: "Dr. Doom", isOnline: true),
////            FirebaseUser(email: "witch@gmail.com", name: "Scarlet Witch", isOnline: true),
////            FirebaseUser(email: "strange@gmail.com", name: "Dr. Strange", isOnline: true),
////            FirebaseUser(email: "thanos@gmail.com", name: "Thanos", isOnline: false),
////            FirebaseUser(email: "spider@gmail.com", name: "Spider Man", isOnline: true),
////            FirebaseUser(email: "lord@gmail.com", name: "Star Lord", isOnline: true),
////            FirebaseUser(email: "groot@gmail.com", name: "I'm Groot", isOnline: false),
////            FirebaseUser(email: "collector@gmail.com", name: "The Collector", isOnline: true),
////            FirebaseUser(email: "adam@gmail.com", name: "Adam Warlock", isOnline: true),
////            FirebaseUser(email: "hulk@gmail.com", name: "The Hulk", isOnline: true),
////            FirebaseUser(email: "panther@gmail.com", name: "Black Panther", isOnline: true),
////            FirebaseUser(email: "iceman@gmail.com", name: "Iceman", isOnline: true),
////            FirebaseUser(email: "thor@gmail.com", name: "Thor", isOnline: true),
////            FirebaseUser(email: "torch@gmail.com", name: "Human Torch", isOnline: true),
////            FirebaseUser(email: "daredevil@gmail.com", name: "Daredevil", isOnline: true)
////        ]
////    }
//
//    func fetchUsers() {
//        
//        Task { [weak self] in
//            do {
//                let snapshot = try await db.collection(Constants.usersCollection).getDocuments(source: .server)
//                
//                self?.users = snapshot.documents.compactMap { doc in
//                    try? doc.data(as: FirebaseUser.self)
//                }
//                debugPrint("Users ----> \(self?.users ?? [])")
//            } catch {
//                print("❌ Failed to fetch users: \(error)")
//            }
//        }
//    }
//    
//    func observeUsers() {
//        listner = db.collection(Constants.usersCollection).order(by: "name").addSnapshotListener({ snapshot, error in
//            guard let snapshot = snapshot, error == nil else {
//                return
//            }
//            let updatedUsers = snapshot.documents.compactMap { doc in
//                try? doc.data(as: FirebaseUser.self)
//            }
//            let data = try! JSONEncoder().encode(updatedUsers)
//            let json = try! JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as! [[String:Any]]
//            debugPrint("Updated users ---> \(json)")
//        })
//    }
//
////    func observeUsers() {
////
////        Task {
////            return await withCheckedContinuation { continuation in
////                observeUsers { snapshot, error  in
////                    continuation.resume()
////                }
////            }
////        }
////    }
//    
//    func removeListners() async {
//        listner?.remove()
//        listner = nil
//    }
//}
