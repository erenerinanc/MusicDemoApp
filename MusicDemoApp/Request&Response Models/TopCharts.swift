//
//  TopCharts.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 29.09.2021.
//

import Foundation

extension APIRequest {
    static func getTopCharts(with storeFrontID: String) -> APIRequest {
        return APIRequest(path: "/catalog/\(storeFrontID)/charts", parameters: ["types":"songs"])
    }
}

// MARK: - TopCharts
struct TopCharts: Codable {
    let results: TopChartResults?
    let meta: TopChartMeta?
}

// MARK: - TopChartMeta
struct TopChartMeta: Codable {
    let results: MetaResults?
}

// MARK: - MetaResults
struct MetaResults: Codable {
    let order: [String]?
}

// MARK: - TopChartResults
struct TopChartResults: Codable {
    let songs: [Song]?
}

// MARK: - Song
struct Song: Codable {
    let chart, name, orderID, next: String?
    let data: [SongData]?
    let href: String?

    enum CodingKeys: String, CodingKey {
        case chart, name
        case orderID = "orderId"
        case next, data, href
    }
}

// MARK: - SongData
struct SongData: Codable {
    let id: String?
    let type: TypeEnum?
    let href: String?
    let attributes: SongAttributes?
}

// MARK: - SongAttributes
struct SongAttributes: Codable {
    let previews: [Preview]?
    let artwork: SongArtwork?
    let artistName: String?
    let url: String?
    let discNumber: Int?
    let genreNames: [String]?
    let durationInMillis: Int?
    let releaseDate, name, isrc: String?
    let hasLyrics: Bool?
    let albumName: String?
    let playParams: SongPlayParams?
    let trackNumber: Int?
    let composerName, contentRating: String?
}

// MARK: - SongArtwork
struct SongArtwork: Codable {
    let width, height: Int?
    let url, bgColor, textColor1, textColor2: String?
    let textColor3, textColor4: String?
}

// MARK: - SongPlayParams
struct SongPlayParams: Codable {
    let id: String?
    let kind: Kind?
}

enum Kind: String, Codable {
    case song = "song"
}

// MARK: - Preview
struct Preview: Codable {
    let url: String?
}

enum TypeEnum: String, Codable {
    case songs = "songs"
}

