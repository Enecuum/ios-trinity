//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit
import EFQRCode

protocol BuyViewDelegate {
}

class BuyView: UIView, NibView {

    @IBOutlet weak var titleLabel: UILabel!
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
    }
}