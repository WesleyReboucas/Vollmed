//
//  AuthenticationManager.swift
//  Vollmed
//
//  Created by Wesley Rebouças on 18/11/23.
//

import Foundation

class AuthenticationManager: ObservableObject {
    
    static let shared = AuthenticationManager()
    
    @Published var token: String?
    @Published var patientID: String?
    
    private init() {
        self.token = KeychainHelper.get(for: "app-vollmed-token")
        self.patientID = KeychainHelper.get(for: "app-vollmed-patient-id")
    }
    
    // MARK: - Save Token
    func saveToken(token: String) {
        KeychainHelper.save(value: token, key: "app-vollmed-token")
        DispatchQueue.main.async {
            self.token = token
        }
    }
    
    // MARK: - Remove Token
    func removeToken() {
        KeychainHelper.remove(for: "app-vollmed-token")
        DispatchQueue.main.async {
            self.token = nil
        }
    }
    
    // MARK: - Save PatientID
    func savePatientID(id: String) {
        KeychainHelper.save(value: id, key: "app-vollmed-patient-id")
        DispatchQueue.main.async {
            self.patientID = id
        }
    }
    
    // MARK: - Remove PatientID
    func removePatientID() {
        KeychainHelper.remove(for: "app-vollmed-patient-id")
        DispatchQueue.main.async {
            self.patientID = nil
        }
    }
}
