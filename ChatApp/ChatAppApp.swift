//
//  ChatAppApp.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 26/08/25.
//

import SwiftUI
import Firebase

@main
struct ChatAppApp: App {


    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: View {
    
    @StateObject private var vm = FirebaseAuthViewModel()
    
    var body: some View {
        Group {
            switch vm.state {
            case .loading:
                BouncingDotsLoader()
            case .signedOut:
                FirebaseAuthView()
                    .environmentObject(vm)
            case .signedIn(let user):
                MainTabView(user: user)
                    .environmentObject(vm)
                //UserProfileView(user: user)
//                UserListView()
//                    .environmentObject(vm)
            }
        }
        .animation(.easeInOut, value: vm.state)
        .onDisappear {
            // RootView should almost never disappear in a simple app,
            // but nothing retained here anyway.
        }
    }
}
