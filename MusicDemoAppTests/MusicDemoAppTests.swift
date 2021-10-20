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
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.protocolClasses = [StubURLProtocol.self]
        api.urlSession = URLSession(configuration: sessionConfig)
        sut = LibraryViewController(
            musicAPI: api,
            storefrontID: "", musicPlayer: SystemMusicPlayer(),
            worker: LibraryWorker(musicAPI: api, storeFrontID: "")
        )
    }

    func testPlaylistsWhenViewDidLoad() {
        // When
        StubURLProtocol.data = "{json}}".data(using: .utf8)!
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

/// URLProtocol for simplifying unit tests by acting man-in-the-middle on for the session.
/// It's configured to work only with test targets. It won't work if there's no test process in progress.
public final class StubURLProtocol: URLProtocol {

    /// Result of the request, which is going to happen.
    public static var data: Data!

}

extension StubURLProtocol {

    public override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    public override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }

    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    public override func startLoading() {
        self.client?.urlProtocol(self, didLoad: StubURLProtocol.data)
    }

    public override func stopLoading() {
        // Nothing to handle
    }

}
