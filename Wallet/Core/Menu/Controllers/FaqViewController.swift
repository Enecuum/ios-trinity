//
// Created by Daria Kokareva on 30/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class FaqViewController: UIViewController {

    @IBOutlet weak var faqTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let title1 = "Battery life\n\n"
        let text1 = "In terms of СPU/GPU usage PoA node does not carry out mining in the ordinary Proof-of-Work way. Instead Enecuum PoA mobile node performs cryptographic validations and signings which is similar to the process during opening a web site via https (secure connection). As a result the battery usage by Enecuum mobile app is comparable to mobile browser or chat work. You never think about battery life choosing secure chat or secure web site over unsecure, right?\n\n"
        let title2 = "Network usage\n\n"
        let text2 = "The analogy with browser continues speaking of the Internet traffic usage by Enecuum app. You probably do not watch YouTube or download movies via mobile network so with Enecuum — we recommend to start PoA activity connected to a WiFi spot if you have limited or payable data plan. Actual consumed traffic volume depends on the network load and the number of online PoA participants and aimed to be light in the future mainnet achievable by rewards/fees stimulation. But during testnet activities traffic volume is not guaranteed to be persistent and predictable.\n\n"
        let title3 = "Support\n\n"
        let text3 = "Feel free to ask for help in the Telegram group"

        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: R.font.ttNormsMedium(size: 17)!,
            .foregroundColor: UIColor.white,
        ]
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: R.font.ttNormsMedium(size: 13)!,
            .foregroundColor: UIColor.white,
        ]

        let attributedString = NSMutableAttributedString()
        attributedString.append(NSAttributedString(string: title1, attributes: titleAttributes))
        attributedString.append(NSAttributedString(string: text1, attributes: textAttributes))
        attributedString.append(NSAttributedString(string: title2, attributes: titleAttributes))
        attributedString.append(NSAttributedString(string: text2, attributes: textAttributes))
        attributedString.append(NSAttributedString(string: title3, attributes: titleAttributes))
        attributedString.append(NSAttributedString(string: text3, attributes: textAttributes))
        attributedString.setAsLink(text: "Telegram group", url: "https://t.me/Enecuum_EN")
        faqTextView.attributedText = attributedString

        let linkAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: Palette.linkColor,
            NSAttributedString.Key.underlineColor: Palette.linkColor,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        faqTextView.linkTextAttributes = linkAttributes
    }

    @IBAction func onBackClicked(_ sender: Any) {
        dismiss(animated: false)
    }

    @IBAction func onDismissClicked(_ sender: Any) {
        dismiss(animated: false)
    }
}
