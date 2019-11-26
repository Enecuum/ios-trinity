//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

protocol QrSideViewDelegate {
    func onQRClicked()
    func onBackClicked()
}

class QRSideView: UIView, NibView {

    @IBOutlet weak var frameView: UIImageView!
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var backButton: UIButton!

    var delegate: QrSideViewDelegate?

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

    // MARK: - Private Methods

    private func setupUI() {
        fold()
    }

    private func fold() {
        backButton.isHidden = true
        frameView.transform.tx = -backButton.bounds.width
    }

    private func unfold() {
        backButton.isHidden = false
        frameView.transform.tx = 0
    }

    // MARK: - IB Actions

    @IBAction func onQRClicked(_ sender: Any) {
        unfold()
        delegate?.onQRClicked()
    }

    @IBAction func onBackClicked(_ sender: Any) {
        fold()
        delegate?.onBackClicked()
    }
}
