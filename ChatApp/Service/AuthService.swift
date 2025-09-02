//
//  FirebaseManager.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 26/08/25.
//

import Foundation
import FirebaseAuth

enum AuthState: Equatable {
    case loading
    case signedOut
    case signedIn(user: FirebaseUser)
}

// MARK: - AuthService.swift

protocol AuthServicing: AnyObject {
    func signIn(email: String, password: String) async throws -> AuthDataResult
    func signUp(email: String, password: String) async throws -> AuthDataResult
    func signOut() throws
    func addAuthStateListener(_ onChange: @escaping (User?) -> Void) -> AuthStateDidChangeListenerHandle
    func removeAuthStateListener(_ handle: AuthStateDidChangeListenerHandle)
}

final class AuthService: AuthServicing {
    
    private let auth = Auth.auth()
    
    func signIn(email: String, password: String) async throws -> AuthDataResult {
        // FirebaseAuth has async APIs on recent versions
        try await auth.signIn(withEmail: email, password: password)
    }
    
    func signUp(email: String, password: String) async throws -> AuthDataResult {
        try await auth.createUser(withEmail: email, password: password)
    }
    
    func signOut() throws {
        try auth.signOut()
    }
    
    func addAuthStateListener(_ onChange: @escaping (User?) -> Void) -> AuthStateDidChangeListenerHandle {
        auth.addStateDidChangeListener { _, user in
            onChange(user)
        }
    }
    
    func removeAuthStateListener(_ handle: AuthStateDidChangeListenerHandle) {
        auth.removeStateDidChangeListener(handle)
    }
    
    deinit {
        print("🔻 AuthService deinit")
    }
}

