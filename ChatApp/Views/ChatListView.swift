//
//  ChatListView.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 01/09/25.
//

import SwiftUI

struct ChatListView: View {
    
    @State private var showUsersList: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State private var chat: Chat?
    @State private var showChatView = false
    @EnvironmentObject private var fbViewModel: FirebaseAuthViewModel
    @ObservedObject var viewModel: ChatListViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                
                if viewModel.isLoading {
                    BouncingDotsLoader()
                }
                else if let error = viewModel.errorMessage {
                    Text(error)
                }
                else {
                    VStack {
                        
                        List(viewModel.chats, id: \.id) { chat in
                            NavigationLink {
                                ChatView(receiverId: chat.receiverId, senderId: chat.senderId, chat: chat)
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "person.fill")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .clipShape(Circle())
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(chat.name)
                                            .font(.system(size: 18, weight: .medium))
                                            .foregroundColor(.primary)
                                        Text(chat.lastMessage)
                                            .font(.system(size: 13, weight: .bold))
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                }
                                .padding(.vertical, 8)
                            }

                        }
                        
                    }
                }
                
                NavigationLink("", isActive: $showChatView) {
                    if let chat = chat {
                        ChatView(receiverId: chat.receiverId, senderId: chat.senderId, chat: chat)
                    }
                }
            }
            .navigationBarTitle("Chats")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showUsersList.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .fullScreenCover(isPresented: $showUsersList) {
                        UserListView() { user in
                            self.chat = nil
                            let chat = Chat(name: user.name, email: user.email, lastMessage: "", timeStamp: Date(), senderId: fbViewModel.currentUser?.id ?? "", receiverId: user.id ?? "")
                            self.chat = chat
                            self.showChatView.toggle()
                        }
                    }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ChatListView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
//        ChatListView()
    }
}
