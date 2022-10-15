//
//  KeychainService.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2022-10-01.
//  Copyright © 2022 Gabriel Siu. All rights reserved.
//

import Foundation

private enum KeychainConstants {
  static let bundleID = "com.gabrielsiu.pocketgg"
}

enum KeychainError: Error {
  case itemNotFound
  case duplicateItem
  case unexpectedData
  case unexpectedStatus(OSStatus)
}

enum Token: String {
  case accessToken
  case refreshToken
}

final class KeychainService {
  
  static func saveToken(_ token: String, _ type: Token) throws {
    let data = token.data(using: .utf8)!
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: type.rawValue,
      kSecAttrService as String: KeychainConstants.bundleID,
      kSecValueData as String: data
    ]
    
    let status = SecItemAdd(query as CFDictionary, nil)
    guard status == errSecSuccess else {
      if status == errSecDuplicateItem {
        throw KeychainError.duplicateItem
      }
      throw KeychainError.unexpectedStatus(status)
    }
  }
  
  static func updateToken(_ token: String, _ type: Token) throws {
    let data = token.data(using: .utf8)!
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: type.rawValue,
      kSecAttrService as String: KeychainConstants.bundleID
    ]
    let attributes: [String: Any] = [
      kSecValueData as String: data
    ]
    
    let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
    guard status == errSecSuccess else {
      if status == errSecItemNotFound {
        throw KeychainError.itemNotFound
      }
      throw KeychainError.unexpectedStatus(status)
    }
  }
  
  static func getToken(_ type: Token) throws -> String {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: type.rawValue,
      kSecAttrService as String: KeychainConstants.bundleID,
      kSecMatchLimit as String: kSecMatchLimitOne,
      kSecReturnData as String: true
    ]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status == errSecSuccess else {
      if status == errSecItemNotFound {
        throw KeychainError.itemNotFound
      }
      throw KeychainError.unexpectedStatus(status)
    }
    guard let data = item as? Data,
          let token = String(data: data, encoding: .utf8) else {
      throw KeychainError.unexpectedData
    }
    
    return token
  }
  
  static func upsertToken(_ token: String, _ type: Token) throws {
    do {
      _ = try getToken(type)
      try updateToken(token, type)
    } catch KeychainError.itemNotFound {
      try saveToken(token, type)
    }
  }
  
  static func deleteToken(_ type: Token) throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: type.rawValue,
      kSecAttrService as String: KeychainConstants.bundleID
    ]
    
    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw KeychainError.unexpectedStatus(status)
    }
  }
}
