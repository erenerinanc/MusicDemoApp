//
//  MusicDemoAppTests.swift
//  MusicDemoAppTests
//
//  Created by Rashid Ramazanov on 10/20/21.
//

import XCTest
@testable import MusicDemoApp

class MusicDemoAppTests: XCTestCase {

    var sut: LibraryViewController!

    override func setUp() {
        let api = AppleMusicFeed(developerToken: "", userToken: "")
        sut = LibraryViewController(
            musicAPI: api,
            storefrontID: "",
            worker: LibraryWorkerSpy()
        )
    }

    func testPlaylistsWhenViewDidLoad() {
        // When
        sut.interactor?.fetchPlaylists()
        // Then
        XCTAssertEqual(sut.playlistViewModel?.playlists.count, 4)
    }

    func testTopchartsWhenViewDidLoad() {
        // When
        sut.interactor?.fetchTopCharts()
        // Then
        XCTAssertEqual(sut.topSongsViewModel?.topSongs.count, 1)
    }

}

final class LibraryWorkerSpy: LibraryWorkingLogic {

    func fetchPlaylists(_ completion: @escaping (Result<Playlists,Error>) -> Void) {
        let playlists = Playlists(data: [
            PlaylistData(id: "1", type: "t", href: "hr", attributes: nil),
            PlaylistData(id: "2", type: "t", href: "hr", attributes: nil),
            PlaylistData(id: "3", type: "t", href: "hr", attributes: nil),
            PlaylistData(id: "4", type: "t", href: "hr", attributes: nil)
        ], meta: nil)
        completion(.success(playlists))
    }

    func fetchTopCharts(_ completion: @escaping (Result<TopCharts,Error>) -> Void) {
        let charts = TopCharts(results: TopChartResults(songs: [
            .init(chart: "c", name: "n", orderID: "o", next: "",
                  data: [.init(id: "1", type: .songs, href: "h", attributes: nil)
                        ],
                  href: "hr")
        ]), meta: nil)
        completion(.success(charts))
    }
    
}
