//
//  MusicDemoAppTests.swift
//  MusicDemoAppTests
//
//  Created by Rashid Ramazanov on 10/20/21.
//

import XCTest
@testable import MusicDemoApp

class MusicDemoAppTests: XCTestCase {

    var window = UIWindow()
    var sut: LibraryViewController!

    override func setUp() {
        let api = AppleMusicFeed(developerToken: "", userToken: "")
        sut = LibraryViewController(
            musicAPI: api,
            storefrontID: "",
            worker: LibraryWorkerSpy()
        )
        let container = ApplicationContainer(musicPlayer: SystemMusicPlayer(), rootViewController: sut)
        window.addSubview(container.view)
        RunLoop.current.run(until: Date())
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

    func testMediaPlayerPlaysAtIndex_WhenTableViewItemIsSelected() {
        // Given
        let newSongIndex = 1
        let indexPath = IndexPath(row: newSongIndex, section: 1)
        let tableView = sut.tableView
        sut.interactor?.fetchTopCharts()
        // When
        sut.tableView(tableView, didSelectRowAt: indexPath)
        // Then
        XCTAssertEqual(sut.appMusicPlayer?.currentIndexInSongsArray, newSongIndex)
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
