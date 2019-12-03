//
//  ViewController.swift
//  wallet
//
//  Created by Daria Kokareva on 01/09/2019.
//  Copyright © 2019 Enecuum. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    @IBOutlet weak var welcomeLabel: UILabel!

    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressBorderView: UIView!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var addressMaskView: UIView!

    @IBOutlet weak var privateKeyLabel: UILabel!
    @IBOutlet weak var privateKeyBorderView: UIView!
    @IBOutlet weak var privateKeyTextField: UITextField!
    @IBOutlet weak var privateKeyMaskView: UIView!

    @IBOutlet weak var errorLabel: UILabel!

    @IBOutlet weak var startButton: GradientButton!

    @IBOutlet weak var warningLabel: UILabel!

    struct Constants {
        static let acceptableChars = "0123456789abcdef"
    }

    var authMode: AuthMode = .walletImport

    override func viewDidLoad() {
        super.viewDidLoad()

        welcomeLabel.text = CurrencyFormat.welcomeCurrencyString()
        addressLabel.text = R.string.localizable.your_address.localized()
        privateKeyLabel.text = R.string.localizable.your_private_key.localized()
        warningLabel.text = R.string.localizable.disclaimer.localized()

        startButton.multilineLabel()

        if Localization.isRTL() {
            addressTextField.textAlignment = .right
            privateKeyTextField.textAlignment = .right
        }

        if authMode == .walletImport {
            addressView.isHidden = true
            errorLabel.alpha = 0

            privateKeyTextField.isUserInteractionEnabled = true
            addGradientMask(textField: privateKeyTextField, maskView: privateKeyMaskView)

            startButton.setTitle(R.string.localizable.import_wallet.localized(), for: .normal)
        } else {
            errorLabel.isHidden = true

            privateKeyTextField.isUserInteractionEnabled = false
            addressTextField.isUserInteractionEnabled = false

            addGradientMask(textField: addressTextField, maskView: addressMaskView)
            addGradientMask(textField: privateKeyTextField, maskView: privateKeyMaskView)

            startButton.setTitle(R.string.localizable.start_using_wallet.localized(), for: .normal)

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
        let newWallet = CryptoHelper.generateKeyPair()
        addressTextField.text = newWallet.address
        privateKeyTextField.text = newWallet.privateKey
    }

    private func importWallet() {
        privateKeyTextField.endEditing(true)

        guard let privateKey = privateKeyTextField.text else {
            setImportError(true, errorText: "Incorrect format of private key")
            return
        }

        let normalizedPrivateKey = CryptoHelper.normalizePrivateKey(privateKey)
        if normalizedPrivateKey.count != CryptoHelper.Constants.privateKeyLength {
            print("Incorrect format of private key")

            setImportError(true, errorText: "Incorrect format of private key")
            return
        }

        if !CryptoHelper.isValidPrivateKey(normalizedPrivateKey) {
            print("Invalid private key")

            setImportError(true, errorText: "Invalid private key")
            return
        }
        openWallet(normalizedPrivateKey)
    }

    private func createNewWallet() {
        guard let address = addressTextField.text, address.count == CryptoHelper.Constants.publicKeyLength else {
            setImportError(true, errorText: "Unknown error")
            print("Invalid address")
            return
        }
        guard let privateKey = privateKeyTextField.text, privateKey.count == CryptoHelper.Constants.privateKeyLength else {
            setImportError(true, errorText: "Unknown error")
            print("Invalid private key")
            return
        }
        openWallet(privateKey)
    }

    private func openWallet(_ key: String) {
        AuthManager.signIn(key)

        let initialViewController = R.storyboard.main().instantiateInitialViewController()
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        appDelegate?.window?.rootViewController = initialViewController
    }
}

extension AuthViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setImportError(false)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == addressTextField {
            privateKeyTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            onStartClicked()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charSet = NSCharacterSet(charactersIn: Constants.acceptableChars).inverted
        let filtered = string.components(separatedBy: charSet).joined(separator: "")
        return (string == filtered)
    }
}
