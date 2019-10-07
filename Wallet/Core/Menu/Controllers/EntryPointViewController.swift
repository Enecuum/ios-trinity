//
// Created by Daria Kokareva on 30/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class EntryPointViewController: UIViewController {

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var entryPointTextField: UITextField!

    struct Constants {
        static let acceptableChars = "0123456789."
    }

    private var confirmedPrivateKey: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        entryPointTextField.text = "\(ApiRouter.baseIp)"
    }

    // MARK: - UI

    private func setError(_ error: Bool) {
        borderView.borderColor = error ? Palette.errorRed : Palette.borderGray
    }

    // MARK: - IBActions

    @IBAction func onSaveUrlClicked(_ sender: Any) {
        if let ip = entryPointTextField.text, isValidIp(ip) {
            Defaults.setBaseIP(ip)
            dismiss(animated: false)
        } else {
            setError(true)
        }
    }

    @IBAction func onBackClicked(_ sender: Any) {
        dismiss(animated: false)
    }

    // MARK: - Validation

    private func isValidIp(_ ip: String) -> Bool {
        let parts = ip.components(separatedBy: ".")
        let nums = parts.compactMap { Int($0) }
        return parts.count == 4 && nums.count == 4 && nums.filter { $0 >= 0 && $0 < 256 }.count == 4
    }
}

extension EntryPointViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setError(false)
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