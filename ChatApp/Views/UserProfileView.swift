//
//  UserProfileView.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 27/08/25.
//

import SwiftUI

struct UserProfileView: View {
    
    @StateObject var fbViewModel: FirestoreViewModel = FirestoreViewModel()
    @EnvironmentObject private var viewModel: FirebaseAuthViewModel
    @State var user: FirebaseUser
    @State private var isEdit: Bool = false
    
    var body: some View {
        
        NavigationView {
            
            List {
                
                Section {
                    TextField("Name", text: $user.name)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                        .disabled(isEdit ? false : true)
                    TextField("Email", text: $user.email)
                        .disabled(true)
                        .foregroundColor(.secondary)
                    
                } header: {
                    Text("Personal Details")
                }
                
                Section {
                    Toggle("Online", isOn: $user.isOnline)
                        .disabled(isEdit ? false : true)
                } header: {
                    Text("Availability")
                }
                
                Section {
                    
                    Button(action: {
                        // Handle signup action
                        fbViewModel.updateCollection(user: user)
                        isEdit.toggle()
                    }) {
                        Text("Update")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(16)
                            .background(Color.pink)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .opacity(isEdit ? 1.0 : 0.5)
                    .disabled(isEdit ? false : true)
                }
            }
            .navigationTitle("Profile")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Toggle edit mode
                        isEdit.toggle()
                    } label: {
                        Image(systemName: isEdit ? "checkmark" : "pencil")
                            .font(.title2)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Button("Logout") {
                        viewModel.signOut()
                    }
                }
            }
        }
    }
}

//struct UserProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserProfileView()
//    }
//}
