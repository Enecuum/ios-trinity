//
// Created by Daria Kokareva on 24/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit
import QRCodeReader
import AVFoundation

class TransferViewController: UIViewController {

    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var balanceAmountLabel: UILabel!

    @IBOutlet weak var tabsView: TabsView!
    @IBOutlet weak var sendView: SendView!
    @IBOutlet weak var receiveView: ReceiveView!
    @IBOutlet weak var swapView: SwapView!

    struct Constants {
        static let apiToBalanceMultiplier: NSDecimalNumber = NSDecimalNumber(mantissa: 1,
                                                                             exponent: -10,
                                                                             isNegative: false)
        static let balanceToApiMultiplier: NSDecimalNumber = NSDecimalNumber(mantissa: 1,
                                                                             exponent: 10,
                                                                             isNegative: false)
    }

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

    override func viewDidLoad() {
        super.viewDidLoad()

        dismissKeyBoardOnTouchOutside()

        balanceTitleLabel.text = R.string.localizable.balance.localized()

        tabsView.setButtonTitles(buttonTitles: [R.string.localizable.send.localized(), R.string.localizable.receive.localized()])
        tabsView.textColor = .white
        tabsView.selectorTextColor = .white
        tabsView.delegate = self
        tabsView.setIndex(index: 0)

        sendView.isHidden = false
        sendView.delegate = self
        receiveView.isHidden = true
        receiveView.delegate = self
        swapView.isHidden = true

        balanceAmountLabel.text = "\(Defaults.getBalance() ?? 0)"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        fetchBalance { [weak self] amount in
            if let amount = amount {
                Defaults.saveBalance(amount)
                self?.balanceAmountLabel.text = "\(amount)"
                self?.sendView.updateMaxValue(maxValue: amount)
            }
        }
    }

    // MARK: - Public methods

    func resetBalance() {
        balanceAmountLabel.text = "\(Defaults.getBalance() ?? 0)"
    }

    // MARK: - Server

    private func fetchBalance(completion: @escaping (NSDecimalNumber?) -> Void) {
        ApiClient.balance(id: CryptoHelper.getPublicKey()) { result in
            switch result {
            case .success(let balanceAmount):
                debugPrint(balanceAmount)
                let amount = NSDecimalNumber(value: balanceAmount.amount).multiplying(by: Constants.apiToBalanceMultiplier)
                completion(amount)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }

    private func postTransaction(_ transaction: Transaction) {
        view.showLoader()
        ApiClient.transaction(transaction) { [weak self] result in
            self?.view.hideLoader()
            switch result {
            case .success(let transactionStatus):
                debugPrint(transactionStatus)
                if transactionStatus.err == 0 {
                    self?.sendView.setTransactionStatus(success: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension TransferViewController: CustomSegmentedControlDelegate {
    func changeToIndex(index: Int) {
        switch index {
        case 0:
            sendView.isHidden = false
            receiveView.isHidden = true
            swapView.isHidden = true
        case 1:
            sendView.isHidden = true
            receiveView.isHidden = false
            swapView.isHidden = true
        case 2:
            sendView.isHidden = true
            receiveView.isHidden = true
            swapView.isHidden = false
        default: ()
        }
    }
}

extension TransferViewController: QRCodeReaderViewControllerDelegate {
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }

    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
    }

    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        dismiss(animated: true, completion: nil)
    }
}

extension TransferViewController: SendViewDelegate {
    func checkMaxSendValue(completion: @escaping (NSDecimalNumber?) -> Void) {
        view.showLoader()
        fetchBalance { [weak self] amount in
            self?.view.hideLoader()
            completion(amount)
            if let amount = amount {
                self?.balanceAmountLabel.text = "\(amount)"
            }
        }
    }

    func readQrCode() {
        readerVC.delegate = self
        readerVC.completionBlock = { [weak self] (result: QRCodeReaderResult?) in
            if let address = result?.value {
                debugPrint(address)
                self?.sendView.setReceiverAddress(address: address)
            }
        }
        readerVC.modalPresentationStyle = .formSheet
        present(readerVC, animated: true, completion: nil)
    }

    func sendEnq(to address: String, amount: NSDecimalNumber) {
        let amountToSendInEnqCents = amount.multiplying(by: Constants.balanceToApiMultiplier)
        let fromAddress = CryptoHelper.getPublicKey()
        let random = UInt32.random(in: 0...UInt32.max)
        let txHash = CryptoHelper.buildTxHash(amount: "\(amountToSendInEnqCents)",
                                              random: "\(random)",
                                              from: fromAddress,
                                              to: address)
        let sign = CryptoHelper.sign(txHash)
        let amountStr = "\(amountToSendInEnqCents)"
        if let amoutUint64 = UInt64(amountStr) {
            let transaction = Transaction(amount: amoutUint64,
                                          from: fromAddress,
                                          nonce: random,
                                          sign: sign,
                                          to: address)
            postTransaction(transaction)
        } else {
            print("Transaction object failed")
        }
    }
}

extension TransferViewController: ReceiveViewDelegate {
    func shareQrCode(image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        present(activityViewController, animated: true, completion: nil)
    }
}
