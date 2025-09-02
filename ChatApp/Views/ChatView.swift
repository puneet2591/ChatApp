//
//  ChatView.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 28/08/25.
//
import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    let chat: Chat
    
    init(receiverId: String, senderId: String, chat: Chat) {
        self.chat = chat
        _viewModel = StateObject(wrappedValue: ChatViewModel(receiverId: receiverId, senderId: senderId, chat: chat))
    }
    
    var body: some View {
        ZStack {
            //LinearGradient(gradient: .init(colors: [.orange, .white, .green]), startPoint: .top, endPoint: .bottom)
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(viewModel.messages) { msg in
                                ChatViewRow(viewModel: viewModel, message: msg)
                            }
                        }
                    }
                    .onChange(of: viewModel.messages.count) { _ in
                        if let last = viewModel.messages.last {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }
                Divider()
                HStack {
                    TextField("Message", text: $viewModel.inputText)
                        .textFieldStyle(.roundedBorder)
                    Button("Send") { viewModel.sendMessage() }
                        .disabled(viewModel.inputText.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(.horizontal)
                .padding(.bottom)
                .padding(.top, 4)
            }
            .clipped()
        }
        .navigationTitle(chat.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChatViewRow : View {
    
    @ObservedObject var viewModel: ChatViewModel
    var message: Message
    
    var body: some View {
        HStack {
            if message.senderId == viewModel.senderId { Spacer() }
            Text(message.text)
                .padding(8)
                .background(message.senderId == viewModel.senderId ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(message.senderId == viewModel.senderId ? .white : .primary)
                .cornerRadius(8)
                .id(message.id)
            if message.senderId != viewModel.senderId { Spacer() }
        }
        .padding(.horizontal)
    }
}
