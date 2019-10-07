//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

protocol SendViewDelegate {
    func checkMaxSendValue(completion: @escaping (NSDecimalNumber?) -> Void)
    func readQrCode()
    func sendEnq(to address: String, amount: NSDecimalNumber)
}

protocol TransactionSender {
    func updateMaxValue(maxValue: NSDecimalNumber)
    func setReceiverAddress(address: String)
    func setTransactionStatus(success: Bool)
}

class SendView: UIView, NibView {

    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var receiverBorderView: UIView!
    @IBOutlet weak var receiverTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var sendAmountBorderView: UIView!
    @IBOutlet weak var sendAmountTextField: UITextField!
    @IBOutlet weak var amountSlider: Slider!

    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var confirmReceiverLabel: UILabel!
    @IBOutlet weak var confirmAmountLabel: UILabel!
    @IBOutlet weak var rejectButton: UIButton!
    @IBOutlet weak var confirmButton: GradientButton!

    @IBOutlet weak var doneView: UIView!
    @IBOutlet weak var circleImageView: UIImageView!

    struct Constants {
        static let addressLength: Int = 66
        static let acceptableAmountChars = "0123456789."
        static let acceptableAddressChars = "0123456789abcdef"
    }

    var delegate: SendViewDelegate?
    //TODO: remove
    private var amountToSend: NSDecimalNumber?

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

    // MARK: - UI

    private func setup() {
        errorLabel.alpha = 0
        sendAmountTextField.text = "0"
        amountSlider.value = 0
        amountSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)

        addAttributedButton(rejectButton, image: R.image.icons.cross()!, string: "  Reject", color: .red)
        addAttributedButton(confirmButton, image: R.image.icons.tick()!, string: "  Confirm", color: .white)
    }

    private func addAttributedButton(_ button: UIButton, image: UIImage, string: String, color: UIColor) {
        let font = R.font.ttNormsMedium(size: 13)!

        let imageAttachment = NSTextAttachment()
        imageAttachment.image = image
        let imageSize = imageAttachment.image!.size
        imageAttachment.bounds = CGRect(x: CGFloat(0),
                                        y: (font.capHeight - imageSize.height) / 2,
                                        width: imageSize.width,
                                        height: imageSize.height)
        let imageString = NSMutableAttributedString(attachment: imageAttachment)

        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: style
        ]
        let label = NSMutableAttributedString(string: string, attributes: attributes)
        label.insert(imageString, at: 0)
        button.setAttributedTitle(label, for: .normal)
        button.setTitleColor(color, for: .normal)
    }

    @objc private func sliderValueChanged(_ sender: UISlider) {
        sendAmountTextField.text = "\(Int(sender.value))"
    }

    private func setReceiverError(_ error: Bool, errorText: String? = nil) {
        receiverBorderView.borderColor = error ? Palette.errorRed : Palette.borderGray
        errorLabel.alpha = error ? 1 : 0
        errorLabel.text = errorText
    }

    private func setAmountError(_ error: Bool) {
        sendAmountBorderView.borderColor = error ? Palette.errorRed : Palette.borderGray
    }

    private func openConfirmView(_ amountToSend: NSDecimalNumber) {
        self.amountToSend = amountToSend

        confirmReceiverLabel.text = receiverTextField.text
        confirmAmountLabel.text = "\(amountToSend)"
        confirmView.isHidden = false
    }

    // MARK: - Conversion

    private func decimal(with string: String) -> NSDecimalNumber {
        let escapedString = string.replacingOccurrences(of: ".", with: ",")
        let formatter = NumberFormatter()
        formatter.generatesDecimalNumbers = true
        return formatter.number(from: escapedString) as? NSDecimalNumber ?? 0
    }

    // MARK: - IBActions

    @IBAction private func onQrClicked(_ sender: Any) {
        delegate?.readQrCode()
    }

    @IBAction private func onSendClicked(_ sender: Any) {
        guard let address = receiverTextField.text, !address.isEmpty, CryptoHelper.isValidPublicKey(address) else {
            setReceiverError(true, errorText: "Invalid address")
            print("Invalid address")
            return
        }
        guard let amount = sendAmountTextField.text, !amount.isEmpty else {
            setAmountError(true)
            print("Invalid amount")
            return
        }

        let amountToSend = NSDecimalNumber(string: amount)
        if amountToSend == NSDecimalNumber.zero || amountToSend.compare(NSDecimalNumber.zero) == .orderedAscending {
            setAmountError(true)
            print("Invalid amount")
            return
        }

        delegate?.checkMaxSendValue { [weak self] maxSendValue in
            guard let maxSendValue = maxSendValue,
                  (amountToSend.compare(maxSendValue) == .orderedAscending || amountToSend.compare(maxSendValue) == .orderedSame) else {
                print("User amount is unknown or not enough to continue the transaction")
                self?.setAmountError(true)
                return
            }
            self?.openConfirmView(amountToSend)
        }
    }

    @IBAction private func onRejectClicked(_ sender: Any) {
        amountToSend = nil
        confirmView.isHidden = true
    }

    @IBAction private func onConfirmClicked(_ sender: Any) {
        if let to = confirmReceiverLabel.text, let amountToSend = amountToSend {
            delegate?.sendEnq(to: to, amount: amountToSend)
        }
    }
}

extension SendView: TransactionSender {
    func updateMaxValue(maxValue: NSDecimalNumber) {
        amountSlider.maximumValue = maxValue.floatValue
    }

    func setReceiverAddress(address: String) {
        receiverTextField.text = address
        setReceiverError(false)
    }

    func setTransactionStatus(success: Bool) {
        circleImageView.rotate(duration: 3)

        doneView.isHidden = false

        receiverTextField.text = ""
        sendAmountTextField.text = "0"
        amountSlider.value = 0

        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [weak self] in
            self?.confirmView.isHidden = true
            self?.doneView.isHidden = true
        })
    }
}

extension SendView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == receiverTextField {
            setReceiverError(false)
        } else {
            setAmountError(false)
        }
        DispatchQueue.main.async {
            textField.selectAll(nil)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == sendAmountTextField {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            if let amount = sendAmountTextField.text, !amount.isEmpty {
                let number = decimal(with: amount)
                if number.floatValue > amountSlider.maximumValue {
                    sendAmountTextField.text = "\(Int(amountSlider.maximumValue))"
                    amountSlider.value = amountSlider.maximumValue
                } else {
                    amountSlider.value = number.floatValue
                }
            } else {
                textField.text = "0"
                amountSlider.value = 0
            }
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == receiverTextField {
            sendAmountTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let charSet: CharacterSet = {
            if textField == receiverTextField {
                return NSCharacterSet(charactersIn: Constants.acceptableAddressChars).inverted
            } else {
                return NSCharacterSet(charactersIn: Constants.acceptableAmountChars).inverted
            }
        }()
        let filtered = string.components(separatedBy: charSet).joined(separator: "")
        return (string == filtered)
    }
}
