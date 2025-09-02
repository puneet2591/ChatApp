//
//  ChatViewModel.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 28/08/25.
//

import Foundation
import FirebaseFirestore

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var errorMessage: String?
    @Published var inputText: String = ""
    
    let senderId: String
    var channelId: String?
    let chat: Chat
    
    private let receiverId: String
    private let service: ChatServiceProtocol
    private var listener: ListenerRegistration?
    
    init(receiverId: String, senderId: String, service: ChatServiceProtocol = ChatService(), chat: Chat) {
        self.receiverId = receiverId
        self.senderId = senderId
        self.service = service
        self.chat = chat
        checkForChannelIdAndFetchMessages()
    }
    
    private func checkForChannelIdAndFetchMessages() {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let channel = ChannelService()
                let channelId = try await channel.createOrGetChannel(senderId: senderId, recipientId: receiverId)
                self.channelId = channelId
                //self.fetchMessages(channelId: channelId)
                self.observeMessages(channelId: channelId)
            } catch {
                debugPrint("Error while creating channel id: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchMessages(channelId: String) {
        Task { [weak self] in
            guard let self = self else { return }
            do {
                let messages = try await self.service.fetchMessages(channelId: channelId)
                self.messages = messages
            } catch {
                debugPrint("Error while fetching messages: \(error.localizedDescription)")
            }
        }
    }
    
    private func observeMessages(channelId: String) {
        do {
            debugPrint("Listener added and observing messages")
            listener = try service.addMessageListener(channelId: channelId, listener: { [weak self] snapshot, error in
                guard let self = self else { return }
                Task { @MainActor in
                    
                    if let error = error {
                        self.errorMessage = "Messages listener error: \(error.localizedDescription)"
                        return
                    }
                    guard let docs = snapshot?.documents else {
                        self.messages = []
                        return
                    }
                    
                    // Map documents to Message and filter to the pair
                    let fetched: [Message] = docs.compactMap { doc in
                        try? doc.data(as: Message.self)
                    }
                    
                    debugPrint("Message received: \(fetched)")
                    self.messages = fetched
                }
            })
            
        }
        catch {
            debugPrint("Error while fetching messages: \(error.localizedDescription)")
        }
    }
    
    func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let newMessage = Message(
            email: chat.email,
            senderId: senderId,
            receiverId: chat.receiverId,
            text: inputText,
            timestamp: Date())
        inputText = ""
        
        Task { [weak self] in
            guard let self = self, let channelId = channelId else { return }
            do {
                try await self.service.sendMessage(channelId: channelId, name: chat.name, message: newMessage)
            } catch {
                await MainActor.run { self.errorMessage = error.localizedDescription }
            }
        }
    }
    
    deinit {
        if let listener = listener { service.removeListener(listener) }
        print("🔻 ChatViewModel deinit")
    }
}

