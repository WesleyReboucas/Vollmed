//
//  UserDefaultsHelper.swift
//  Vollmed
//
//  Created by Wesley Rebouças on 17/11/23.
//

import Foundation

struct UserDefaultsHelper {
    
    // MARK: - Save
    static func save(value: String, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    // MARK: - Get
    static func get(for key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    // MARK: - Remove
    static func remove(for key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
