//
//  ArtistDetailsViewController.swift
//  MusicDemoApp
//
//  Created by Eren Erinanç on 8.10.2021.
//

import UIKit
import WebKit
import SnapKit

class ArtistDetailsViewController: BaseViewController, UIToolbarDelegate, WKNavigationDelegate {
    let webView = WKWebView()
    var webURL: String?
    
    init(url: String) {
        super.init()
        self.webURL = url
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var toolbar = UIToolbar().configure {
        $0.delegate = self
        if #available(iOS 13, *) {
            $0.barTintColor = .systemBackground
        } else {
            $0.barTintColor = .white
        }
        
        $0.isTranslucent = false
        $0.tintColor = .systemRed
        
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapDoneButton(_:)))
        $0.setItems([closeButton], animated: false)
    }
    
    @objc private func didTapDoneButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .top
    }
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(toolbar)
        toolbar.snp.makeConstraints { $0.top.leading.trailing.equalToSuperview() }
        
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(toolbar.snp.bottom)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let webURL = webURL else { return}
        let url = URL(string: webURL)!
        let urlRequest = URLRequest(url: url)
        webView.navigationDelegate = self
        webView.load(urlRequest)
        webView.allowsBackForwardNavigationGestures = true
    }
    

}
