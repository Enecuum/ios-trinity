//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit
import EFQRCode
import Nantes

protocol BuyViewDelegate {
}

class BuyView: UIView, NibView {

    @IBOutlet weak var titleLabel: NantesLabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var buyButton: UIButton!


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

        let linkText = CurrencyFormat.buyNativeCoinString()
        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: linkText, attributes: linkAttributes))
        attributedString.append(NSAttributedString(string: R.string.localizable.buy_native_title.localized(),
                                                   attributes: textAttributes))
        titleLabel.attributedText = attributedString
        titleLabel.addLink(to: URL(string: "https://guides.enecuum.com/how-by-card/")!,
                           withRange: (attributedString.string as NSString).range(of: linkText))
        titleLabel.delegate = self

        buyButton.setTitle(CurrencyFormat.buyCurrencyString(), for: .normal)
    }
}

extension BuyView: NantesLabelDelegate {
    public func attributedLabel(_ label: NantesLabel, didSelectLink link: URL) {
        Browser.openUrl(link)
    }
}
