//
// Created by Daria Kokareva on 30/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class PrivateKeyViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var privateKeyTextField: UITextField!

    @IBOutlet weak var importLabel: UILabel!
    @IBOutlet weak var importView: UIView!
    @IBOutlet weak var importButton: GradientButton!
    
    @IBOutlet weak var newPrivateKeyTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!

    @IBOutlet weak var warningIconView: UIImageView!
    @IBOutlet weak var warningTitleLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!

    struct Constants {
        static let privateKeyLength: Int = 64
        static let acceptableChars = "0123456789abcdef"
        static let unwindSegueId = "unwindToMainSegue"
    }

    private var confirmedPrivateKey: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = R.string.localizable.private_key.localized()
        importButton.setTitle(R.string.localizable.import_wallet.localized(), for: .normal)
        importButton.multilineLabel()
        importLabel.text = R.string.localizable.private_key_import_hint.localized()
        signInButton.setTitle(R.string.localizable.signin.localized(), for: .normal)
        signInButton.multilineLabel()
        warningTitleLabel.text = R.string.localizable.import_key_warning_title.localized()
        warningLabel.text = R.string.localizable.import_key_warning.localized()

        privateKeyTextField.text = AuthManager.key()

        if Localization.isRTL() {
            privateKeyTextField.textAlignment = .right
            newPrivateKeyTextField.textAlignment = .right
        }
    }

    // MARK: - UI

    private func setImportError(_ error: Bool, errorText: String? = nil) {
        importView.borderColor = error ? Palette.errorRed : Palette.borderGray
    }

    private func fakeAppReload() {
        let mainViewController = R.storyboard.main.mainViewController()
        view.window?.rootViewController = mainViewController
    }

    // MARK: - IBActions

    @IBAction func onCopyPrivateKeyClicked(_ sender: Any) {
        UIPasteboard.general.string = privateKeyTextField.text
    }

    @IBAction func onImportClicked(_ sender: Any) {
        importLabel.isHidden = false
        importView.isHidden = false
        signInButton.isHidden = false
        warningIconView.isHidden = false
        warningTitleLabel.isHidden = false
        warningLabel.isHidden = false
    }

    @IBAction func onSignInClicked(_ sender: Any) {
        newPrivateKeyTextField.endEditing(true)

        guard let newPrivateKey = newPrivateKeyTextField.text, newPrivateKey.count == Constants.privateKeyLength else {
            print("Incorrect format of private key")

            setImportError(true)
            return
        }

        if !CryptoHelper.isValidPrivateKey(newPrivateKey) {
            print("Invalid private key")

            setImportError(true)
            return
        }

        confirmedPrivateKey = newPrivateKey

        let confirmViewController = R.storyboard.menu.confirmViewController()!
        confirmViewController.confirmText = R.string.localizable.import_new_private_key.localized()
        confirmViewController.modalPresentationStyle = .overCurrentContext
        confirmViewController.modalTransitionStyle = .crossDissolve
        confirmViewController.delegate = self
        present(confirmViewController, animated: false)
    }

    @IBAction func onBackClicked(_ sender: Any) {
        dismiss(animated: false)
    }
}

extension PrivateKeyViewController: ConfirmViewDelegate {
    func onConfirmClicked() {
        if let key = confirmedPrivateKey {
            Defaults.clearUserData()
            AuthManager.signIn(key)

            fakeAppReload()
        }
    }

    func onCancelClicked() {
        confirmedPrivateKey = nil
    }
}

extension PrivateKeyViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setImportError(false)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charSet = NSCharacterSet(charactersIn: Constants.acceptableChars).inverted
        let filtered = string.components(separatedBy: charSet).joined(separator: "")
        return (string == filtered)
    }
}
