//
//  MainTabView.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 29/08/25.
//

import SwiftUI

struct MainTabView: View {
    
    @StateObject var user: FirebaseUser
//    @StateObject private var firestoreViewModel = FirestoreViewModel()
    @EnvironmentObject private var firebaseAuthViewModel: FirebaseAuthViewModel
    @StateObject private var chatListViewModel: ChatListViewModel = ChatListViewModel()
    
    var body: some View {
        TabView {
            UserProfileView(user: user)
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
            
            ChatListView(viewModel: chatListViewModel)
                .tabItem {
                    Label("Chats", systemImage: "message")
                }
//            UserListView(viewModel: firestoreViewModel)
//                .environmentObject(viewModel)
//                .tabItem {
//                    Label("Chats", systemImage: "message")
//                }
        }
        .task {
            //firestoreViewModel.loadUsers(id: viewModel.currentUser?.id ?? "")
            await chatListViewModel.fetchChats()
        }
        // optional style for iOS 16+
        .tint(.blue)
    }
}


struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
