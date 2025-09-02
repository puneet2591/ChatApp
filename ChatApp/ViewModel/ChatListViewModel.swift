//
//  ChatListViewModel.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 01/09/25.
//

import Foundation

@MainActor
final class ChatListViewModel: ObservableObject {
    
    @Published var chats: [Chat] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    let service: FirestoreServiceProtocol
    let fbManager = FirebaseManager.shared
    
    init(service: FirestoreServiceProtocol = FirestoreService()) {
        self.service = service
    }
    
    func fetchChats() async {
        errorMessage = nil
        isLoading = true
        
        guard let id = FirebaseManager.shared.firebase.currentUser?.uid else { return }
        do {
            let list: [Chat] = try await self.service.fetchCollection(path: Constants.chatsCollection)
            let filteredList = list.filter{$0.id != id}
            if filteredList.count > 0 {
                self.chats = filteredList
            } else {
                self.errorMessage = "Star chat"
            }
        } catch {
            self.errorMessage = error.localizedDescription
        }
        self.isLoading = false
    }
    
    func observeMessages() async {
        
    }
}
