//
//  FirestoreViewModel.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 28/08/25.
//

import Foundation

@MainActor
final class FirestoreViewModel: ObservableObject {
    @Published var users: [FirebaseUser] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var lastMessage = ""
    
    private let firestoreService: FirestoreServiceProtocol
    private var task: Task<Void, Never>?
    private let channelService = ChannelService()
    private let chatService: ChatServiceProtocol = ChatService()
    
    init(firestoreService: FirestoreServiceProtocol = FirestoreService()) {
        self.firestoreService = firestoreService
    }
    
    func loadUsers(id: String) {
        errorMessage = nil
        isLoading = true
        task?.cancel()
        
        task = Task { [weak self] in
            guard let self = self else { return }
            do {
                let list: [FirebaseUser] = try await self.firestoreService.fetchCollection(path: Constants.usersCollection)
                let filteredList = list.filter{$0.id != id}
                //self.observeLastMessages()
                await MainActor.run { self.users = filteredList }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
            await MainActor.run { self.isLoading = false }
        }
    }
    
    func updateCollection(user: FirebaseUser) {
        errorMessage = nil
        isLoading = true
        task?.cancel()
        task = Task { [weak self] in
            guard let self = self else { return }
            do {
                try await self.firestoreService.updateCollection(path: Constants.usersCollection, user: user)
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
            await MainActor.run { self.isLoading = false }
        }
    }
    
    deinit {
        task?.cancel()
        print("🔻 FirestoreViewModel deinit")
    }
}

