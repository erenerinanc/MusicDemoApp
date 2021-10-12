//
//  Playlists.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 26.09.2021.
//

import Foundation

extension APIRequest {
    static func getLibraryPlaylists() -> APIRequest {
        return APIRequest(path: "/me/library/playlists", parameters: [:])
    }
}

// MARK: - Playlists
struct Playlists: Codable {
    let data: [PlaylistData]?
    let meta: Meta?
}

// MARK: - PlaylistData
struct PlaylistData: Codable {
    let id, type, href: String?
    let attributes: Attributes?
}

// MARK: - Attributes
struct Attributes: Codable {
    let playParams: PlayParams?
    let isPublic: Bool?
    let artwork: Artwork?
    let canEdit: Bool?
    let attributesDescription: Description?
    let hasCatalog: Bool?
    let name: String?
    let dateAdded: String?

    enum CodingKeys: String, CodingKey {
        case playParams, isPublic, artwork, canEdit
        case attributesDescription = "description"
        case hasCatalog, name, dateAdded
    }
}

// MARK: - Artwork
struct Artwork: Codable {
    let width, height: JSONNull?
    let url: String?
}

// MARK: - Description
struct Description: Codable {
    let standard: String?
}

// MARK: - PlayParams
struct PlayParams: Codable {
    let id, kind: String?
    let isLibrary: Bool?
    let globalID: String?

    enum CodingKeys: String, CodingKey {
        case id, kind, isLibrary
        case globalID = "globalId"
    }
}

// MARK: - Meta
struct Meta: Codable {
    let total: Int?
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
