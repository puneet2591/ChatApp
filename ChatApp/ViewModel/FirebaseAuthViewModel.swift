//
//  FirebaseAuthViewModel.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 26/08/25.
//

import SwiftUI
import FirebaseAuth
import Firebase

@MainActor
final class FirebaseAuthViewModel: ObservableObject {
    @Published private(set) var state: AuthState = .loading
    @Published var errorMessage: String?
    @Published var isBusy: Bool = false
    @Published var currentUser: FirebaseUser?
    
    private let service: AuthServicing
    private var authHandle: AuthStateDidChangeListenerHandle?
    private var signTask: Task<Void, Never>?
    private var firestoreManager = FirestoreService()
    
    init(service: AuthServicing = AuthService()) {
        self.service = service
        observeAuthChanges()
    }
    
    private func observeAuthChanges() {
        // Avoid retain cycle by not capturing self in service, and use [weak self] here
        authHandle = service.addAuthStateListener { [weak self] user in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                if let user = user {
                    await self.getCurrenUserMetaData(id: user.uid)
                } else {
                    self.state = .signedOut
                }
            }
        }
    }
    
    private func getCurrenUserMetaData(id: String) async {
        do {
            guard let currentUser: FirebaseUser = try await firestoreManager.fetchCurrentUser(path: Constants.usersCollection, id: id) else { return }
            self.currentUser = currentUser
            self.state = .signedIn(user: currentUser)
        } catch {
            debugPrint("Error fetching current user --> \(error.localizedDescription)")
        }
        
    }
    
    func signIn(email: String, password: String) {
        errorMessage = nil
        isBusy = true
        signTask?.cancel()
        signTask = Task { [weak self] in
            guard let self = self else { return }
            do {
                _ = try await self.service.signIn(email: email, password: password)
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
            await MainActor.run {
                self.isBusy = false
            }
        }
    }
    
    func signUp(email: String, password: String, name: String, isOnline: Bool) {
        errorMessage = nil
        isBusy = true
        signTask?.cancel()
        signTask = Task { [weak self] in
            guard let self = self else { return }
            do {
                let result = try await self.service.signUp(email: email, password: password)
                let user = FirebaseUser(id: result.user.uid, email: email, name: name, isOnline: isOnline)
                await updateUser(user: user)
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                }
            }
            await MainActor.run {
                self.isBusy = false
            }
        }
    }
    
    
    func updateUser(user: FirebaseUser) async {
        do {
            try await firestoreManager.updateCollection(path: Constants.usersCollection, user: user)
        } catch {
            print("❌ Failed to update user: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            try service.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    deinit {
        signTask?.cancel()
        if let authHandle = authHandle {
            service.removeAuthStateListener(authHandle)
        }
        print("🔻 AuthViewModel deinit")
    }
}
