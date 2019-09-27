//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader

protocol SendViewDelegate {
    func updateBalance()
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

    @IBOutlet weak var doneView: UIView!

    struct Constants {
        static let addressLength: Int = 66
        static let ACCEPTABLE_amount_CHARACTERS = "0123456789."
        static let ACCEPTABLE_address_CHARACTERS = "0123456789abcdef"
    }

    var delegate: SendViewDelegate?
    var indicator: UIActivityIndicatorView?

    lazy var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .front)
            $0.showTorchButton = false
            $0.showSwitchCameraButton = true
            $0.showCancelButton = true
            $0.showOverlayView = true
            $0.rectOfInterest = CGRect(x: 0.15, y: 0.15, width: 0.7, height: 0.7)
        }

        return QRCodeReaderViewController(builder: builder)
    }()

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
        errorLabel.isHidden = true
        sendAmountTextField.text = "0"
        amountSlider.value = 0

        let indicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = center
        addSubview(indicator)
        bringSubviewToFront(indicator)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.indicator = indicator

        amountSlider.addTarget(self, action: #selector(changeVlaue(_:)), for: .valueChanged)
    }

    @objc func changeVlaue(_ sender: UISlider) {
        print("value is" , Int(sender.value))
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

    private func openConfirmView(_ amountToSend: Decimal) {
        confirmReceiverLabel.text = receiverTextField.text
        let trimmedString = sendAmountTextField.text?.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
        confirmAmountLabel.text = trimmedString
                //sendAmountTextField.text
             //   "\(NSDecimalNumber(decimal:amountToSend).doubleValue)"
        confirmView.isHidden = false
    }

    func updateBalance(_ amount: Decimal) {
        amountSlider.maximumValue = NSDecimalNumber(decimal:amount).floatValue
    }

    // MARK: - Server

    //TODO: remove
    private func fetchBalance(amountToSend: Decimal) {
        ApiClient.balance(id: CryptoHelper.getAddress()) { [weak self] result in

            self?.indicator?.stopAnimating()

            switch result {
            case .success(let balanceAmount):
                print(balanceAmount)
                guard let decimalAmount = Decimal(string: String(balanceAmount.amount)) else {
                    print("Failed to convert balanceAmount")
                    return
                }
                let amount = decimalAmount * Decimal(0.0000000001)

                if amount < amountToSend {
                    self?.setAmountError(true)
                } else {
                    self?.openConfirmView(amountToSend)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - IBActions

    @IBAction func onQrClicked(_ sender: Any) {
        readerVC.delegate = self
        readerVC.completionBlock = { [weak self] (result: QRCodeReaderResult?) in
            if let resultValue = result?.value {
                print(resultValue)
                var address = resultValue
                address.removeFirst(4)
                self?.receiverTextField.text = address
                self?.setReceiverError(false)
            }
        }
        readerVC.modalPresentationStyle = .formSheet
        UIApplication.topViewController()?.present(readerVC, animated: true, completion: nil)
    }

    @IBAction func onSendClicked(_ sender: Any) {
        delegate?.updateBalance()

        guard let address = receiverTextField.text, !address.isEmpty/*, address.count == Constants.addressLength*/ else {
            setReceiverError(true, errorText: "Invalid address")
            print("Invalid address")
            return
        }
        guard let amount = sendAmountTextField.text, !amount.isEmpty else {
            setAmountError(true)
            print("Invalid amount")
            return
        }

        if let decimalAmount = Decimal(string: amount) {
            if decimalAmount.isZero || decimalAmount.sign == .minus {
                setAmountError(true)
                print("Invalid amount")
                return
            }

            indicator?.startAnimating()

            fetchBalance(amountToSend: decimalAmount)
        } else {
            setAmountError(true)
        }
    }

    @IBAction func onRejectClicked(_ sender: Any) {
        confirmView.isHidden = true
    }

    @IBAction func onConfirmClicked(_ sender: Any) {
        doneView.isHidden = false

        receiverTextField.text = ""
        sendAmountTextField.text = ""
        amountSlider.value = 0

        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: { [weak self] in
            self?.confirmView.isHidden = true
            self?.doneView.isHidden = true
        })
    }
}

extension SendView: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()

        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
    }

    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        let cameraName = newCaptureDevice.device.localizedName
        print("Switching capture to: \(cameraName)")
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()

        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
    }
}

extension SendView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == receiverTextField {
            setReceiverError(false)
        } else {
            setAmountError(false)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == receiverTextField {
            let cs = NSCharacterSet(charactersIn: Constants.ACCEPTABLE_address_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered)
        } else {
            let cs = NSCharacterSet(charactersIn: Constants.ACCEPTABLE_amount_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered)
        }
    }
}
