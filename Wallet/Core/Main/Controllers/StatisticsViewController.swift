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

    @IBOutlet weak var poaNodesAmountLabel: UILabel!
    @IBOutlet weak var posNodesAmountLabel: UILabel!
    @IBOutlet weak var powNodesAmountLabel: UILabel!
    @IBOutlet weak var accountsAmountLabel: UILabel!
    @IBOutlet weak var tpsAmountLabel: UILabel!
    @IBOutlet weak var blocksAmountLabel: UILabel!

    @IBOutlet weak var powRewardAmountLabel: UILabel!
    @IBOutlet weak var posRewardAmountLabel: UILabel!
    @IBOutlet weak var poaRewardAmountLabel: UILabel!

    @IBOutlet weak var circSupplyAmountLabel: UILabel!

    struct Constants {
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addMap()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        fetchStats()
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

    private func fetchStats() {
        ApiClient.stats { [weak self] result in
            switch result {
            case .success(let statistics):
                debugPrint(statistics)

                self?.poaNodesAmountLabel.text = "\(statistics.poa_count ?? 0)"
                self?.posNodesAmountLabel.text = "\(statistics.pos_count ?? 0)"
                self?.powNodesAmountLabel.text = "\(statistics.pow_count ?? 0)"

                self?.accountsAmountLabel.text = "\(statistics.accounts)"
                self?.tpsAmountLabel.text =  "\(statistics.tps ?? 0) / \(statistics.max_tps ?? 0)"

                self?.poaRewardAmountLabel.text = "\(statistics.reward_poa)"
                self?.powRewardAmountLabel.text = "\(statistics.reward_pow)"

                self?.circSupplyAmountLabel.text = "\(statistics.csup)"

            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        ApiClient.blocks{ [weak self] result in
            switch result {
            case .success(let blocksAmount):
                debugPrint(blocksAmount)

                self?.blocksAmountLabel.text = "\(blocksAmount.height)"

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - IBOutlets

    @IBAction func onOpenBrowserMapClicked(_ sender: Any) {
        if let url = URL(string: "https://neuro.enecuum.com") {
            UIApplication.shared.open(url)
        }
    }
}

extension StatisticsViewController: WKUIDelegate {

}
