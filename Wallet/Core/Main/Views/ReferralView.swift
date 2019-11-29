//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit
import EFQRCode

protocol ReferralViewDelegate {
    func shareQrCode(image: UIImage)
}

class ReferralView: UIView, NibView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var qrImageView: UIImageView!

    var delegate: ReferralViewDelegate?

    struct Constants {
        static let staticKey: String = "750D7F2B34CA3DF1D6B7878DEBC8CF9A56BCB51A58435B5BCFB7E82EE09FA8BE75"
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
        titleLabel.text = CurrencyFormat.referralMessage()
        updateReferralQr()
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
            qrImageView.image = UIImage(cgImage: qrImage)
        } else {
            print("Create QRCode image failed!")
        }
    }

    @IBAction func onShareQrClicked(_ sender: Any) {
        if let image = qrImageView.image {
            delegate?.shareQrCode(image: image)
        }
    }
}