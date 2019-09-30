//
// Created by Daria Kokareva on 30/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class PrivateKeyController: UIViewController {

    @IBOutlet weak var privateKeyTextField: UITextField!
    @IBOutlet weak var importLabel: UILabel!
    @IBOutlet weak var importView: UIView!
    @IBOutlet weak var warningIconView: UIImageView!
    @IBOutlet weak var warningLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        privateKeyTextField.text = AuthManager.key()
    }

    @IBAction func onCopyPrivateKeyClicked(_ sender: Any) {
        UIPasteboard.general.string = privateKeyTextField.text
    }

    @IBAction func onImportClicked(_ sender: Any) {
        importLabel.isHidden = false
        importView.isHidden = false
        warningIconView.isHidden = false
        warningLabel.isHidden = false
    }

    @IBAction func onBackClicked(_ sender: Any) {
        dismiss(animated: false)
    }

    @IBAction func onDismissClicked(_ sender: Any) {
        dismiss(animated: false)
    }
}
