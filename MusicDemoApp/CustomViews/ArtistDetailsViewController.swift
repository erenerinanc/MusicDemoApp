//
//  ArtistDetailsViewController.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 8.10.2021.
//

import UIKit
import WebKit
import SnapKit

class ArtistDetailsViewController: BaseViewController, WKNavigationDelegate {
    let webView = WKWebView()
    var webURL: String?
    
    init(url: String) {
        super.init()
        self.webURL = url
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        webView.navigationDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let webURL = webURL else { return}
        let url = URL(string: webURL)!
        let urlRequest = URLRequest(url: url)
        view.addSubview(webView)
        webView.snp.makeConstraints { $0.directionalEdges.equalToSuperview() }
        webView.load(urlRequest)
        webView.allowsBackForwardNavigationGestures = true
    }
    

}
