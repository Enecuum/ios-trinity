//
// Created by Daria Kokareva on 30/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class AddressViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = R.string.localizable.my_address.localized()

        addressTextField.text = CryptoHelper.getPublicKey()

        if Localization.isRTL() {
            addressTextField.textAlignment = .right
        }
    }

    @IBAction func onCopyAddressClicked(_ sender: Any) {
        UIPasteboard.general.string = addressTextField.text
    }

    @IBAction func onBackClicked(_ sender: Any) {
        dismiss(animated: false)
    }
}
