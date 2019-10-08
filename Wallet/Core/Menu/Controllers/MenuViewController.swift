//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    //TODO: extract menu item class
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var myAddressLabel: UILabel!
    @IBOutlet weak var privateKeyLabel: UILabel!
    @IBOutlet weak var communityLabel: UILabel!
    @IBOutlet weak var faqLabel: UILabel!
    @IBOutlet weak var languagesLabel: UILabel!
    @IBOutlet weak var entryPointLabel: UILabel!

    @IBOutlet weak var hiddenView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        aboutLabel.text = R.string.localizable.about.localized()
        myAddressLabel.text = R.string.localizable.my_address.localized()
        privateKeyLabel.text = R.string.localizable.private_key.localized()
        communityLabel.text = R.string.localizable.community.localized()
        faqLabel.text = R.string.localizable.faq.localized()
        languagesLabel.text = R.string.localizable.language.localized()
        entryPointLabel.text = R.string.localizable.entry_point.localized()
    }

    // MARK: - IB Actions

    @IBAction func onDismissClicked(_ sender: Any) {
        dismiss(animated: false)
    }

    @IBAction func onHiddenTap(_ sender: Any) {
        hiddenView.isHidden = false
    }
}
