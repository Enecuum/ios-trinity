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
    @IBOutlet weak var maxSupplyAmountLabel: UILabel!

    struct Constants {
        static let apiToDataMultiplier: NSDecimalNumber = NSDecimalNumber(mantissa: 1,
                                                                          exponent: -10,
                                                                          isNegative: false)
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

                let poaCount = statistics.poa_count ?? 0
                let posCount = statistics.pos_count ?? 0
                let powCount = statistics.pow_count ?? 0

                self?.poaNodesAmountLabel.text = "\(poaCount)"
                self?.posNodesAmountLabel.text = "\(posCount)"
                self?.powNodesAmountLabel.text = "\(powCount)"

                self?.totalNodesCounterLabel.text = "\(poaCount + powCount + posCount)"

                self?.accountsAmountLabel.text = "\(statistics.accounts)"
                self?.tpsAmountLabel.text = "\(statistics.tps ?? 0) / \(statistics.max_tps ?? 0)"

                let numberFormatter = NumberFormatter()
                numberFormatter.groupingSeparator = ","
                numberFormatter.numberStyle = .decimal

                let poaRewardAmount = NSDecimalNumber(value: statistics.reward_poa).multiplying(by: Constants.apiToDataMultiplier)
                self?.poaRewardAmountLabel.text = numberFormatter.string(from: NSNumber(value: poaRewardAmount.int64Value))

                let powRewardAmount = NSDecimalNumber(value: statistics.reward_pow).multiplying(by: Constants.apiToDataMultiplier)
                self?.powRewardAmountLabel.text = numberFormatter.string(from: NSNumber(value: powRewardAmount.int64Value))

                let circSupplyAmount = NSDecimalNumber(value: statistics.csup).multiplying(by: Constants.apiToDataMultiplier)
                self?.circSupplyAmountLabel.text = numberFormatter.string(from: NSNumber(value: circSupplyAmount.int64Value))

                self?.maxSupplyAmountLabel.text = "845,870,425"

            case .failure(let error):
                print(error.localizedDescription)
            }
        }

        ApiClient.blocks { [weak self] result in
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
