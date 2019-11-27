//
// Created by Daria Kokareva on 24/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit
import QRCodeReader
import AVFoundation
import EFQRCode

class HomeViewController: UIViewController {

    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var balanceAmountLabel: UILabel!

    @IBOutlet weak var usdRateLabel: UILabel!
    @IBOutlet weak var amountInUsdLabel: UILabel!

    @IBOutlet weak var qrSideView: QRSideView!
    @IBOutlet weak var referralView: UIView!
    @IBOutlet weak var referralQrImageView: UIImageView!

    struct Constants {
        static let balanceFromApiMultiplier: NSDecimalNumber = NSDecimalNumber(mantissa: 1,
                                                                               exponent: -10,
                                                                               isNegative: false)
        static let balanceToApiMultiplier: NSDecimalNumber = NSDecimalNumber(mantissa: 1,
                                                                             exponent: 10,
                                                                             isNegative: false)

        static let staticKey: String = "750D7F2B34CA3DF1D6B7878DEBC8CF9A56BCB51A58435B5BCFB7E82EE09FA8BE75"
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

    private func updateReferralQr() {
        let uintPublicKey = Array(hex: CryptoHelper.getPublicKey())
        let uintStaticKey = Array(hex: Constants.staticKey)
        let xor = LogicOperation.xor(uintPublicKey, uintStaticKey).toHexString()

        let generator = EFQRCodeGenerator(content: "ref_\(xor)", size: EFIntSize(width: 500, height: 500))
        generator.setInputCorrectionLevel(inputCorrectionLevel: .l)
        generator.setColors(backgroundColor: CIColor(color: UIColor(red: 31 / 255,
                                                                    green: 33 / 255,
                                                                    blue: 41 / 255,
                                                                    alpha: 1)),
                            foregroundColor: CIColor(color: UIColor(red: 39 / 255,
                                                                    green: 88 / 255,
                                                                    blue: 163 / 255,
                                                                    alpha: 1)))
        generator.setPointShape(pointShape: .circle)
        if let qrImage = generator.generate() {
            referralQrImageView.image = UIImage(cgImage: qrImage)
        } else {
            print("Create QRCode image failed!")
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
            self?.view.hideLoader()
            if let stake = stake {
                if let balance = Defaults.getBalance(), balance.compare(stake) != .orderedAscending {
                    self?.updateReferralQr()
                    self?.referralView.isHidden = false
                } else {
                    self?.qrSideView.fold()
                    self?.showMinimumStakeDialog(stake)
                }
            } else {
                self?.qrSideView.fold()
                //show dialog error?
            }
        }
    }

    func onBackClicked() {
        referralView.isHidden = true
    }
}

extension HomeViewController: AlertViewControllerDelegate {
    func onConfirmClicked() {
    }

    func onCancelClicked() {}
}