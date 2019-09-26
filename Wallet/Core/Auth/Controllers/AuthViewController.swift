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
    @IBOutlet weak var addressBorderView: UIView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addressMaskView: UIView!

    @IBOutlet weak var privateKeyBorderView: UIView!
    @IBOutlet weak var privateKeyTextField: UITextField!
    @IBOutlet weak var privateKeyMaskView: UIView!

    @IBOutlet weak var errorLabel: UILabel!

    struct Constants {
        static let addressLength: Int = 66
        static let privateKeyLength: Int = 64
    }

    var authMode: AuthMode = .walletImport

    override func viewDidLoad() {
        super.viewDidLoad()

        if authMode == .walletImport {
            addressView.isHidden = true
            errorLabel.alpha = 0

            privateKeyTextField.isUserInteractionEnabled = true
            addGradientMask(textField: privateKeyTextField, maskView: privateKeyMaskView)
        } else {
            errorLabel.isHidden = true

            privateKeyTextField.isUserInteractionEnabled = false
            addressTextField.isUserInteractionEnabled = false

            addGradientMask(textField: addressTextField, maskView: addressMaskView)
            addGradientMask(textField: privateKeyTextField, maskView: privateKeyMaskView)

            generateNewWalletData()
        }
    }

    // MARK: - UI

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
        addressBorderView.borderColor = error ? Palette.errorRed : Palette.borderGray

        let privateKeyCaLayer = privateKeyMaskView.layer as CALayer
        if let gradientLayer = privateKeyCaLayer.sublayers?[0] as? CAGradientLayer {
            let colors = error ? Palette.inputErrorGradient : Palette.inputGradient
            gradientLayer.colors = colors.map { $0.cgColor }
        }
        let addressCaLayer = addressMaskView.layer as CALayer
        if let gradientLayer = addressCaLayer.sublayers?[0] as? CAGradientLayer {
            let colors = error ? Palette.inputErrorGradient : Palette.inputGradient
            gradientLayer.colors = colors.map { $0.cgColor }
        }

        errorLabel.alpha = error ? 1 : 0
        errorLabel.text = errorText
    }

    // MARK: - IBActions

    @IBAction private func onCopyAddressClicked(_ sender: Any) {
        UIPasteboard.general.string = addressTextField.text
    }

    @IBAction private func onCopyPrivateKeyClicked(_ sender: Any) {
        UIPasteboard.general.string = privateKeyTextField.text
    }

    @IBAction private func onStartClicked() {
        switch authMode {
        case .walletCreation:
            createNewWallet()
        case .walletImport:
            importWallet()
        }
    }

    @IBAction private func onBackClicked(_ sender: Any) {
        dismiss(animated: false)
    }

    // MARK: - Wallet

    private func generateNewWalletData() {
        let newWallet = WalletHelper.newWallet()
        addressTextField.text = newWallet.address
        privateKeyTextField.text = newWallet.privateKey
    }

    private func importWallet() {
        privateKeyTextField.endEditing(true)

        guard let privateKey = privateKeyTextField.text, privateKey.count == Constants.privateKeyLength else {
            print("Invalid private key")

            setImportError(true, errorText: "Invalid private key")
            return
        }
        openWallet(privateKey)
    }

    private func createNewWallet() {
        guard let address = addressTextField.text, address.count == Constants.addressLength else {
            setImportError(true, errorText: "Unknown error")
            print("Invalid address")
            return
        }
        guard let privateKey = privateKeyTextField.text, privateKey.count == Constants.privateKeyLength else {
            setImportError(true, errorText: "Unknown error")
            print("Invalid private key")
            return
        }
        openWallet(privateKey)
    }

    private func openWallet(_ key: String) {
        let initialViewController = R.storyboard.main().instantiateInitialViewController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = initialViewController
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setImportError(false)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        onStartClicked()
        return true
    }
}
