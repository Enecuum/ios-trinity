//
// Created by Daria Kokareva on 24/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit
import QRCodeReader
import AVFoundation

class HomeViewController: UIViewController {

    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var balanceAmountLabel: UILabel!

    @IBOutlet weak var usdRateLabel: UILabel!
    @IBOutlet weak var amountInUsdLabel: UILabel!

    @IBOutlet weak var qrSideView: QRSideView!

    struct Constants {
        static let balanceFromApiMultiplier: NSDecimalNumber = NSDecimalNumber(mantissa: 1,
                                                                               exponent: -10,
                                                                               isNegative: false)
        static let balanceToApiMultiplier: NSDecimalNumber = NSDecimalNumber(mantissa: 1,
                                                                             exponent: 10,
                                                                             isNegative: false)
        static let referralViewTag: Int = 1991
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        balanceTitleLabel.text = R.string.localizable.balance.localized()

        balanceAmountLabel.text = "\(Defaults.getBalance() ?? 0)"
        if let usdRate = Defaults.usdRate() {
            self.updateUsdRate(usdRate)
        }

        qrSideView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        fetchBalance { [weak self] amount in
            if let amount = amount {
                Defaults.saveBalance(amount)
                self?.balanceAmountLabel.text = "\(amount)"
            }
        }

        fetchStats()
    }

    // MARK: - Private methods

    private func updateUsdRate(_ usdRate: String) {
        let usdCourse = NSDecimalNumber(string: usdRate)
        self.usdRateLabel.text = CurrencyFormat.asUsdString(usdCourse)

        if let balance = Defaults.getBalance() {
            let usdAmount = usdCourse.multiplying(by: balance)
            self.amountInUsdLabel.text = Formatter.decimalString(usdAmount, fractionDigits: 2)
        }
    }

    private func showMinimumStakeDialog(_ stake: NSDecimalNumber) {
        let alertViewController = R.storyboard.menu.alertViewController()!
        alertViewController.titleText = R.string.localizable.referral_buy_title.localized()
        alertViewController.text = CurrencyFormat.referralBuyMessage(stake)
        alertViewController.confirmText = CurrencyFormat.buyCurrencyString()
        alertViewController.cancelText = R.string.localizable.cancel.localized()
        alertViewController.hasButtonIcons = false
        alertViewController.modalPresentationStyle = .overCurrentContext
        alertViewController.modalTransitionStyle = .crossDissolve
        alertViewController.delegate = self
        present(alertViewController, animated: false)
    }

    // MARK: - Public methods

    func resetBalance() {
        balanceAmountLabel.text = "\(Defaults.getBalance() ?? 0)"
    }

    // MARK: - Server

    private func fetchBalance(completion: @escaping (NSDecimalNumber?) -> Void) {
        ApiClient.balance(id: CryptoHelper.getPublicKey()) { result in
            switch result {
            case .success(let balanceAmount):
                debugPrint(balanceAmount)
                let amount = NSDecimalNumber(value: balanceAmount.amount).multiplying(by: Constants.balanceFromApiMultiplier)
                completion(amount)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }

    private func fetchStats() {
        ApiClient.stats { [weak self] result in
            switch result {
            case .success(let statistics):
                debugPrint(statistics)

                Defaults.setUsdRate(statistics.cg_usd)
                self?.updateUsdRate(statistics.cg_usd)

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func fetchReferrerStake(completion: @escaping (NSDecimalNumber?) -> Void) {
        ApiClient.referrerStake { result in
            switch result {
            case .success(let referrerStake):
                debugPrint(referrerStake)
                completion(NSDecimalNumber(value: referrerStake.referrer_stake))
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }
}

extension HomeViewController: QrSideViewDelegate {
    func onQRClicked() {
        view.showLoader()
        fetchReferrerStake { [weak self] stake in
            guard let self = self else {
                return
            }
            self.view.hideLoader()
            if let stake = stake {
                if let balance = Defaults.getBalance(), balance.compare(stake) != .orderedAscending {
                    self.qrSideView.unfold()
                    let referralView = ReferralView(frame: self.view.bounds)
                    referralView.tag = Constants.referralViewTag
                    referralView.delegate = self
                    self.view.insertSubview(referralView, belowSubview: self.qrSideView)
                } else {
                    self.showMinimumStakeDialog(stake)
                }
            } else {
                //show dialog error?
            }
        }
    }

    func onBackClicked() {
        if let referralView = view.viewWithTag(Constants.referralViewTag) {
            referralView.removeFromSuperview()
        }
    }
}

extension HomeViewController: AlertViewControllerDelegate {
    func onConfirmClicked() {
        //open exchange
    }

    func onCancelClicked() {}
}

extension HomeViewController: ReferralViewDelegate {
    func shareQrCode(image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }
}
