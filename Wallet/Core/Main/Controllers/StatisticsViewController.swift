//
// Created by Daria Kokareva on 24/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit
import QRCodeReader
import AVFoundation
import WebKit

class StatisticsViewController: UIViewController {

    @IBOutlet weak var totalNodesLabel: UILabel!
    @IBOutlet weak var totalNodesCounterLabel: UILabel!

    @IBOutlet weak var mapContainer: UIView!
    
    struct Constants {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addMap()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }

    // MARK: - Private methods

    private func addMap() {
        let mapWidth = view.frame.width * 0.9
        let mapHeight = mapWidth / 2
        let webConfiguration = WKWebViewConfiguration()
        let frame = CGRect(x: 0, y: 0, width: mapWidth, height: mapHeight)
        let webView = WKWebView(frame: frame, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.isOpaque = false

        mapContainer.addSubview(webView)

        let url = URL(string: "https://neuro-release.enecuum.com/map_ios_enq_wallet_transparent.html")!
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }

    // MARK: - Server
    
    // MARK: - IBOutlets
    
    @IBAction func onOpenBrowserMapClicked(_ sender: Any) {
        if let url = URL(string: "https://neuro-release.enecuum.com/map_ios_enq_wallet_transparent.html") {
            UIApplication.shared.open(url)
        }
    }
}

extension StatisticsViewController: WKUIDelegate {

}
