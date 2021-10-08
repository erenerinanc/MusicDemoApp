//
//  Storefront.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 27.09.2021.
//

import Foundation

extension APIRequest {
    static func getStoreFront() -> APIRequest {
        return APIRequest(path: "/me/storefront", parameters: [:])
    }
}
// MARK: - Storefront
struct Storefront: Codable {
    let data: [StorefrontData]?
}

// MARK: - StorefrontData
struct StorefrontData: Codable {
    let id, type, href: String?
    let languageAttributes: LanguageAttribute?
}

// MARK: - Attributes
struct LanguageAttribute: Codable {
    let defaultLanguageTag: String?
    let supportedLanguageTags: [String]?
    let explicitContentPolicy, name: String?
}
