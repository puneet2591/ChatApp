//
//  User.swift
//  ChatApp
//
//  Created by Puneet Mahajan on 26/08/25.
//

import Foundation
import FirebaseFirestoreSwift

class FirebaseUser: Identifiable, Codable, ObservableObject, Equatable {
    
    static func == (lhs: FirebaseUser, rhs: FirebaseUser) -> Bool {
        return true
    }
    
    @DocumentID var id: String?
    var email: String = ""
    @Published var name: String = ""
    @Published var isOnline: Bool = false
    
    init(id: String, email: String, name: String, isOnline: Bool) {
        self.id = id
        self.email = email
        self.name = name
        self.isOnline = isOnline
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case isOnline
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        email = try values.decode(String.self, forKey: .email)
        isOnline = try values.decode(Bool.self, forKey: .isOnline)
    }


    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(isOnline, forKey: .isOnline)
    }
    
}
