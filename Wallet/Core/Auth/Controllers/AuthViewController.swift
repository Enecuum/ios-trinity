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

    @IBOutlet weak var privateKeyBorderView: UIView!
    @IBOutlet weak var privateKeyTextField: UITextField!
    @IBOutlet weak var privateKeyMaskView: UIView!

    @IBOutlet weak var errorLabel: UILabel!

    var authMode: AuthMode = .walletImport

    override func viewDidLoad() {
        super.viewDidLoad()

        if authMode == .walletImport {
            addressView.isHidden = true
            errorLabel.alpha = 0
        } else {
            errorLabel.isHidden = true
        }

        //TODO: remove
        addressTextField.text = "037ac2e935e4ebc1b1512b5e5dfe21436a5e3fccc5b3015c7395mm86dd182ac6"
        privateKeyTextField.text = "037ac2e935e4ebc1b1512b5e5dfe21436a5e3fccc5b3015c7395mm86dd182ac6"

        addGradientMask(textField: addressTextField, maskView: addressMaskView)
        addGradientMask(textField: privateKeyTextField, maskView: privateKeyMaskView)
    }

    private func addGradientMask(textField: UITextField, maskView: UIView) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = Palette.inputGradient.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradientLayer.frame = maskView.bounds
        maskView.layer.addSublayer(gradientLayer)
        maskView.mask = textField
    }

    private func setImportError(_ error: Bool, errorText: String? = nil) {
        privateKeyBorderView.borderColor = error ? Palette.errorRed : Palette.borderGray

        let caLayer = privateKeyMaskView.layer as CALayer
        if let gradientLayer = caLayer.sublayers?[0] as? CAGradientLayer {
            let colors = error ? Palette.inputErrorGradient : Palette.inputGradient
            gradientLayer.colors = colors.map { $0.cgColor }
        }

        errorLabel.alpha = error ? 1 : 0
        errorLabel.text = errorText
    }

    @IBAction private func onCopyAddressClicked(_ sender: Any) {
    }

    @IBAction private func onCopyPrivateKeyClicked(_ sender: Any) {
    }

    @IBAction private func onStartClicked(_ sender: Any) {
        let initialViewController = R.storyboard.main().instantiateInitialViewController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = initialViewController
    }

    @IBAction private func onBackClicked(_ sender: Any) {
        dismiss(animated: false)
    }
}

