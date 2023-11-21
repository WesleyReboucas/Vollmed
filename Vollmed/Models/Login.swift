//
//  Login.swift
//  Vollmed
//
//  Created by Wesley Rebouças on 17/11/23.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case password = "senha"
    }
}

struct LoginResponse: Identifiable, Codable {
    let auth: Bool
    let id: String
    let token: String
}
