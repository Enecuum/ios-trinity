//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit
import AVFoundation
import QRCodeReader

class SendView: UIView, NibView {

    @IBOutlet weak var dataView: UIView!
    @IBOutlet weak var receiverTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var sendAmountTextField: UITextField!
    @IBOutlet weak var amountSlider: Slider!
    
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var doneView: UIView!

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

    private func setup() {
        errorLabel.isHidden = true
        sendAmountTextField.text = "0"
        amountSlider.value = 0
    }

    // MARK: - IBActions

    @IBAction func onQrClicked(_ sender: Any) {
        readerVC.delegate = self
        readerVC.completionBlock = { [weak self] (result: QRCodeReaderResult?) in
            if let resultValue = result?.value {
                print(resultValue)
                self?.receiverTextField.text = resultValue
            }
        }
        readerVC.modalPresentationStyle = .formSheet
        UIApplication.topViewController()?.present(readerVC, animated: true, completion: nil)
    }

    @IBAction func onSendClicked(_ sender: Any) {
        confirmView.isHidden = false
    }

    @IBAction func onRejectClicked(_ sender: Any) {
        confirmView.isHidden = true
    }

    @IBAction func onConfirmClicked(_ sender: Any) {
        doneView.isHidden = false
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
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}