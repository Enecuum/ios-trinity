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
    @IBOutlet weak var qrButton: UIButton!
    @IBOutlet weak var backButton: UIButton!

    struct Constants {
        static let duration: TimeInterval = 0.125
        static let shift: CGFloat = -120
    }

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
        UIView.animate(withDuration: Constants.duration, animations: { [weak self] in
            self?.transform.ty = 0
        })
        backButton.isHidden = true
        frameView.transform.tx = -backButton.bounds.width
        qrButton.isEnabled = true
    }

    // MARK: - Public Methods

    func unfold() {
        UIView.animate(withDuration: Constants.duration, animations: { [weak self] in
            self?.transform.ty = Constants.shift
        })
        qrButton.isEnabled = false
        backButton.isHidden = false
        frameView.transform.tx = 0
    }

    // MARK: - IB Actions

    @IBAction func onQRClicked(_ sender: Any) {
        delegate?.onQRClicked()
    }

    @IBAction func onBackClicked(_ sender: Any) {
        fold()
        delegate?.onBackClicked()
    }
}
