//
//  Search.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 8.10.2021.
//

extension APIRequest {
    static func searchSongsOrArtists(storeFrontID: String, by query: String) -> APIRequest {
        return APIRequest(path: "/catalog/\(storeFrontID)/search", parameters: ["term": query, "limit": "4", "types": "songs,artists"])
    }
}

import Foundation


// MARK: - Search
struct Search: Codable {
    let results: SearchResult?
    let meta: SearchMeta?
}

// MARK: - SearchMeta
struct SearchMeta: Codable {
    let results: SearchMetaResults?
}

// MARK: - SearchMetaResults
struct SearchMetaResults: Codable {
    let order, rawOrder: [String]?
}

// MARK: - SearchResult
struct SearchResult: Codable {
    let songs: Songs?
    let artists: Artists?
}

// MARK: - Artists
struct Artists: Codable {
    let href, next: String?
    let data: [ArtistsData]?
}

// MARK: - ArtistsData
struct ArtistsData: Codable {
    let id, type, href: String?
    let attributes: PurpleAttributes?
    let relationships: Relationships?
}

// MARK: - PurpleAttributes
struct PurpleAttributes: Codable {
    let genreNames: [String]?
    let url: String?
    let name: String?
}

// MARK: - Relationships
struct Relationships: Codable {
    let albums: Albums?
}

// MARK: - Albums
struct Albums: Codable {
    let href: String?
    let data: [AlbumsData]?
}

// MARK: - AlbumsData
struct AlbumsData: Codable {
    let id: String?
    let type: SearchTypeEnum?
    let href: String?
    let attributes: SearchFluffyAttributes?
}

// MARK: - SearchFluffyAttributes
struct SearchFluffyAttributes: Codable {
    let previews: [SearchPreview]?
    let artwork: Artwork?
    let artistName: String?
    let url: String?
    let discNumber: Int?
    let genreNames: [GenreName]?
    let durationInMillis: Int?
    let releaseDate, name, isrc: String?
    let hasLyrics: Bool?
    let albumName: String?
    let playParams: SearchPlayParams?
    let trackNumber: Int?
    let composerName: String?
}

// MARK: - SearchArtwork
struct SearchArtwork: Codable {
    let width, height: Int?
    let url, bgColor, textColor1, textColor2: String?
    let textColor3, textColor4: String?
}

enum GenreName: String, Codable {
    case music = "Music"
    case pop = "Pop"
    case turkishPop = "Turkish Pop"
}

// MARK: - SearchPlayParams
struct SearchPlayParams: Codable {
    let id, kind: String?
}

// MARK: - SearchPreview
struct SearchPreview: Codable {
    let url: String?
}

enum SearchTypeEnum: String, Codable {
    case albums = "albums"
    case songs = "songs"
}

// MARK: - Songs
struct Songs: Codable {
    let href, next: String?
    let data: [SongData]?
}
