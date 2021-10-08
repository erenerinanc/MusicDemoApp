//
//  PlaylistDetails.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 1.10.2021.
//

import Foundation

extension APIRequest {
    static func getCatalogPlaylists(storeFrontID: String, globalID: String) -> APIRequest {
        return APIRequest(path: "/catalog/\(storeFrontID)/playlists/\(globalID)", parameters: [:])
    }
}

// MARK: - CatalogPlaylist
struct CatalogPlaylist: Codable {
    let data: [CatalogPlaylistData]?
}

// MARK: - CatalogPlaylistData
struct CatalogPlaylistData: Codable {
    let id, type, href: String?
    let attributes: CatalogPlaylistDetails?
    let relationships: CatalogPlaylistRelationships?
}

// MARK: - CatalogPlaylistDetails
struct CatalogPlaylistDetails: Codable {
    let artwork: CatalogPlaylisArtwork?
    let isChart: Bool?
    let url: String?
    let lastModifiedDate: String?
    let name, playlistType, curatorName: String?
    let playParams: CatalogPlaylistPlayParams?
    let attributesDescription: Description?

    enum CodingKeys: String, CodingKey {
        case artwork, isChart, url, lastModifiedDate, name, playlistType, curatorName, playParams
        case attributesDescription = "description"
    }
}

// MARK: - CatalogPlaylisArtwork
struct CatalogPlaylisArtwork: Codable {
    let width, height: Int?
    let url: String?
}

// MARK: - CatalogPlaylistDescription
struct CatalogPlaylistDescription: Codable {
    let standard: String?
}

// MARK: - CatalogPlaylistPlayParams
struct CatalogPlaylistPlayParams: Codable {
    let id: String?
    let kind: CatalogPlaylistKind?
}

enum CatalogPlaylistKind: String, Codable {
    case playlist = "playlist"
    case song = "song"
}

// MARK: - CatalogPlaylistRelationships
struct CatalogPlaylistRelationships: Codable {
    let tracks, curator: PlaylistCurator?
}

// MARK: - PlaylistCurator
struct PlaylistCurator: Codable {
    let href: String?
    let data: [CatalogSongData]?
}

// MARK: - CatalogPlaylistcuratorDatum
struct CatalogSongData: Codable {
    let id: String?
    let type: CatalogPlaylistTypeEnum?
    let href: String?
    let attributes: CatalogSong?
}

// MARK: - CatalogSong
struct CatalogSong: Codable {
    let previews: [SongPreview]?
    let artwork: FluffyArtwork?
    let artistName: String?
    let url: String?
    let discNumber: Int?
    let genreNames: [String]?
    let durationInMillis: Int?
    let releaseDate, name, isrc: String?
    let hasLyrics: Bool?
    let albumName: String?
    let playParams: PlayParams?
    let trackNumber: Int?
    let composerName: String?
}

// MARK: - FluffyArtwork
struct FluffyArtwork: Codable {
    let width, height: Int?
    let url, bgColor, textColor1, textColor2: String?
    let textColor3, textColor4: String?
}

// MARK: - SongPreview
struct SongPreview: Codable {
    let url: String?
}

enum CatalogPlaylistTypeEnum: String, Codable {
    case songs = "songs"
}
