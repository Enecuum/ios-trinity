//
//  ViewController.swift
//  wallet
//
//  Created by Daria Kokareva on 01/09/2019.
//  Copyright © 2019 Enecuum. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addressMaskView: UIView!

    @IBOutlet weak var privateKeyTextField: UITextField!
    @IBOutlet weak var privateKeyMaskView: UIView!

    var authMode: AuthMode = .walletImport

    override func viewDidLoad() {
        super.viewDidLoad()

        //TODO: remove
        addressTextField.text = "037ac2e935e4ebc1b1512b5e5dfe21436a5e3fccc5b3015c7395mm86dd182ac6"
        privateKeyTextField.text = "037ac2e935e4ebc1b1512b5e5dfe21436a5e3fccc5b3015c7395mm86dd182ac6"

        addGradientMask(textField: addressTextField, maskView: addressMaskView)
        addGradientMask(textField: privateKeyTextField, maskView: privateKeyMaskView)
    }

    private func addGradientMask(textField: UITextField, maskView: UIView) {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.init(white: 1, alpha: 0.8).cgColor, UIColor.init(white: 1, alpha: 0.1).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.frame = maskView.bounds
        maskView.layer.addSublayer(gradient)
        maskView.mask = textField
    }

    @IBAction private func onCopyAddressClicked(_ sender: Any) {
    }

    @IBAction private func onCopyPrivateKeyClicked(_ sender: Any) {
    }

    @IBAction private func onStartClicked(_ sender: Any) {
    }

    @IBAction private func onBackClicked(_ sender: Any) {
        dismiss(animated: false)
    }
}

