//
//  UserListView.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 26/08/25.
//

import SwiftUI

struct UserListView: View {
    
    @StateObject private var viewModel = FirestoreViewModel()
    @EnvironmentObject private var fbViewModel: FirebaseAuthViewModel
    @Environment(\.dismiss) private var dismiss
    //@Binding var showChatView: Bool
    var didSelectUser: (FirebaseUser) -> ()
    
    var body: some View {
        NavigationView {
            VStack {
                
                if viewModel.isLoading {
                    BouncingDotsLoader()
                }
                else if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                }
                else {
                    List(viewModel.users, id: \.id) { user in
                        
//                        NavigationLink(destination: UserProfileView(fbViewModel: viewModel, user: user)) {
//                        NavigationLink(destination: ChatView(receiverId: user.id ?? "", senderId: fbViewModel.currentUser?.id ?? "", user: user)) {
                            
                            HStack(spacing: 12) {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .clipShape(Circle())
//                                Circle()
//                                    .fill(user.isOnline ? Color.green : Color.gray)
//                                    .frame(width: 8, height: 8)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(user.name)
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(.primary)
                                }
                            }
                            .animation(.linear(duration: 0.9), value: user.isOnline)
                            .padding(.vertical, 8)
                            .onTapGesture {
                                debugPrint("User selected: \(user)")
                                self.didSelectUser(user)
                                dismiss()
                            }
//                        }
                    }
                }
            }
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadUsers(id: fbViewModel.currentUser?.id ?? "")
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        withAnimation(.none) {
                            dismiss()
                        }
                    } label: {
                        Text("Cancel")
                    }

                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

//struct UserRowView: View {
//    var body: some View {
//        List(1..<10) { _ in
//            Image(systemName: "person.fill")
//                .resizable()
//                .frame(width: 20, height: 20)
//                .border(.black)
//                .clipShape(Circle())
//            Circle()
//                .fill(Color.green)
//                .frame(width: 8, height: 8)
//            VStack(alignment: .leading, spacing: 3) {
//                Text("Tony Stark")
//                    .font(.system(size: 18, weight: .medium))
//                    .foregroundColor(.primary)
//                Text("Online")
//                    .font(.system(size: 12, weight: .light))
//                    .foregroundColor(.secondary)
//            }
//        }
//    }
//}
//
//struct UserRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserRowView()
//    }
//}
