//
//  Patient.swift
//  Vollmed
//
//  Created by Wesley Rebouças on 17/11/23.
//

import Foundation

struct Patient: Identifiable, Codable {
    let id: String?
    let name: String
    let email: String
    let cpf: String
    let phoneNumber: String
    let password: String
    let healthPlan: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case cpf
        case email
        case name  = "nome"
        case password = "senha"
        case phoneNumber = "telefone"
        case healthPlan = "planoSaude"
    }
    
}
