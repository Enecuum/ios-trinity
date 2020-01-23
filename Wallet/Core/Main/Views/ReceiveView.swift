//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit
import EFQRCode

protocol ReceiveViewDelegate {
    func shareQrCode(image: UIImage)
}

class ReceiveView: UIView, NibView {

    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addressTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var borderImageViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var shareQrButton: UIButton!

    var delegate: ReceiveViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        roundCorners(corners: [.topRight, .topLeft], radius: 25)
    }

    private func setup() {
        shareQrButton.setTitle("  \(R.string.localizable.share_qr.localized())", for: .normal)

        let key = CryptoHelper.getPublicKey()
        addressTextField.text = key

        let generator = EFQRCodeGenerator(content: key, size: EFIntSize(width: 500, height: 500))
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
            qrImageView.image = UIImage(cgImage: qrImage)
        } else {
            print("Create QRCode image failed!")
        }

        if Localization.isRTL() {
            addressTextField.textAlignment = .right
        }

        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            tuneForSE()
        }
    }

    // MARK: - Size Tuning

    private func tuneForSE() {
        addressTopConstraint.constant = 30
        borderImageViewConstraint.constant = 160
    }

    // MARK: - IB Actions

    @IBAction func onCopyAddressClicked(_ sender: Any) {
        UIPasteboard.general.string = addressTextField.text
        showToastMessage(R.string.localizable.copied_address.localized(), extraPadding: BottomTabsView.Constants.height)
    }

    @IBAction func onShareQrClicked(_ sender: Any) {
        if let image = qrImageView.image {
            delegate?.shareQrCode(image: image)
        }
    }
}
