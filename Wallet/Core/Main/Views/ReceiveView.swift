//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class ReceiveView: UIView, NibView {

    @IBOutlet weak var addressTextField: UITextField!
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
        addressTextField.text = CryptoHelper.getAddress()
    }
    
    @IBAction func onCopyAddressClicked(_ sender: Any) {
        UIPasteboard.general.string = addressTextField.text
    }
}
