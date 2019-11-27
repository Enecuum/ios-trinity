//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit
import EFQRCode
import Nantes

class BuyInExchangeView: UIView, NibView {

    @IBOutlet weak var titleLabel: NantesLabel!

    @IBOutlet weak var kucoinImageView: UIImageView!
    @IBOutlet weak var kucoinBtcButton: UIButton!
    @IBOutlet weak var kucoinUsdtButton: UIButton!

    @IBOutlet weak var crexImageView: UIImageView!
    @IBOutlet weak var crexBtcButton: UIButton!
    @IBOutlet weak var crexUsdButton: UIButton!
    @IBOutlet weak var crexRubButton: UIButton!

    @IBOutlet weak var graviexImageView: UIImageView!
    @IBOutlet weak var graviexBtcButton: UIButton!
    @IBOutlet weak var graviexEthButton: UIButton!
    @IBOutlet weak var graviexUsdtButton: UIButton!

    struct Constants {
        static let bottomPadding: CGFloat = 9
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setupUI()
    }

    private func setupUI() {
        let linkColor = UIColor(red: 105 / 255, green: 110 / 255, blue: 170 / 255, alpha: 1)
        let linkAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: linkColor,
            .font: R.font.ttNormsMedium(size: 16)!,
            .underlineColor: linkColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: R.font.ttNormsMedium(size: 16)!,
            .foregroundColor: UIColor.white,
        ]

        let linkTextPart = R.string.localizable.buy_erc_20_title_link.localized()
        let attributedString = NSMutableAttributedString()

        attributedString.append(NSAttributedString(string: R.string.localizable.buy_erc_20_title.localized(),
                                                   attributes: textAttributes))
        let linkPartRange = (attributedString.string as NSString).range(of: linkTextPart)
        attributedString.addAttributes(linkAttributes, range: linkPartRange)

        titleLabel.attributedText = attributedString
        titleLabel.addLink(to: URL(string: "https://guides.enecuum.com/how-to-swap/")!, withRange: linkPartRange)
        titleLabel.delegate = self

        let kucoinTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                       action: #selector(openKucoin))
        kucoinImageView.addGestureRecognizer(kucoinTap)
        kucoinBtcButton.setTitle(CurrencyFormat.coinToBtcString(), for: .normal)
        kucoinUsdtButton.setTitle(CurrencyFormat.coinToUsdtString(), for: .normal)

        let crexTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                     action: #selector(openCrex))
        crexImageView.addGestureRecognizer(crexTap)
        crexBtcButton.setTitle(CurrencyFormat.coinToBtcString(), for: .normal)
        crexUsdButton.setTitle(CurrencyFormat.coinToUsdString(), for: .normal)
        crexRubButton.setTitle(CurrencyFormat.coinToRubString(), for: .normal)

        let graviexTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                        action: #selector(openGraviex))
        graviexImageView.addGestureRecognizer(graviexTap)
        graviexBtcButton.setTitle(CurrencyFormat.coinToBtcString(), for: .normal)
        graviexEthButton.setTitle(CurrencyFormat.coinToEthString(), for: .normal)
        graviexUsdtButton.setTitle(CurrencyFormat.coinToUsdtString(), for: .normal)

    }

    @objc private func openKucoin() {
        Browser.openUrl("https://www.kucoin.com/")
    }

    @objc private func openCrex() {
        Browser.openUrl("https://crex24.com/?refid=c36hkj32l6utjurdd2wt")
    }

    @objc private func openGraviex() {
        Browser.openUrl("https://graviex.net")
    }

    // MARK: - IB Actions

    @IBAction func kucoinBtcButtonClicked(_ sender: Any) {
        Browser.openUrl("https://www.kucoin.com/trade/\(CurrencyFormat.Constants.currency)-BTC")
    }

    @IBAction func kucoinUsdtButtonClicked(_ sender: Any) {
        Browser.openUrl("https://www.kucoin.com/trade/\(CurrencyFormat.Constants.currency)-USDT")
    }

    @IBAction func crexBtcButtonClicked(_ sender: Any) {
        Browser.openUrl("https://crex24.com/exchange/\(CurrencyFormat.Constants.currency)-BTC?refid=c36hkj32l6utjurdd2wt")
    }

    @IBAction func crexUdsButtonClicked(_ sender: Any) {
        Browser.openUrl("https://crex24.com/exchange/\(CurrencyFormat.Constants.currency)-USD?refid=c36hkj32l6utjurdd2wt")
    }

    @IBAction func crexRubButtonClicked(_ sender: Any) {
        Browser.openUrl("https://crex24.com/exchange/\(CurrencyFormat.Constants.currency)-RUB?refid=c36hkj32l6utjurdd2wt")
    }

    @IBAction func graviexBtcButtonClicked(_ sender: Any) {
        Browser.openUrl("https://graviex.net/markets/\(CurrencyFormat.Constants.currency)btc")
    }

    @IBAction func graviexEthButtonClicked(_ sender: Any) {
        Browser.openUrl("https://graviex.net/markets/\(CurrencyFormat.Constants.currency)eth")
    }

    @IBAction func graviexUsdtButtonClicked(_ sender: Any) {
        Browser.openUrl("https://graviex.net/markets/\(CurrencyFormat.Constants.currency)usdt")
    }
}

extension BuyInExchangeView: NantesLabelDelegate {
    public func attributedLabel(_ label: NantesLabel, didSelectLink link: URL) {
        Browser.openUrl(link)
    }
}
