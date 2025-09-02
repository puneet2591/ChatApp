//
//  FirebaseManager.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 02/09/25.
//

import Foundation
import FirebaseAuth

final class FirebaseManager {
    
    static let shared = FirebaseManager()
    let firebase = Auth.auth()
    
    private init() { }
}
