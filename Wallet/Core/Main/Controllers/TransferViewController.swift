//
// Created by Daria Kokareva on 24/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit
import QRCodeReader
import AVFoundation

class TransferViewController: UIViewController {

    @IBOutlet weak var balanceAmountLabel: UILabel!

    @IBOutlet weak var tabsView: TabsView!
    @IBOutlet weak var sendView: SendView!
    @IBOutlet weak var receiveView: ReceiveView!
    @IBOutlet weak var swapView: SwapView!

    struct Constants {
        static let apiToBalanceMultiplier: Decimal = Decimal(0.0000000001)
        static let balanceToApiMultiplier: Decimal = Decimal(10000000000)
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

        tabsView.setButtonTitles(buttonTitles: ["Send", "Receive", "SWAP"])
        tabsView.selectorViewColor = .white
        tabsView.selectorTextColor = .white
        tabsView.textColor = .white
        tabsView.delegate = self

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

    private func fetchBalance(completion: @escaping (Decimal?) -> Void) {
        ApiClient.balance(id: CryptoHelper.getPublicKey()) { result in
            switch result {
            case .success(let balanceAmount):
                debugPrint(balanceAmount)
                guard let decimalAmount = Decimal(string: String(balanceAmount.amount)) else {
                    print("Failed to convert balanceAmount")
                    completion(nil)
                    return
                }
                let amount = decimalAmount * Constants.apiToBalanceMultiplier
                completion(amount)
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        }
    }

    private func postTransaction(_ transaction: Transaction) {
        ApiClient.transaction(transaction) { [weak self] result in
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
    func checkMaxSendValue(completion: @escaping (Decimal?) -> Void) {
        //start progress
        fetchBalance { [weak self] amount in
            //stop progress
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

    func sendEnq(to address: String, amount: Decimal) {
        let amountToSendInEnqCents = amount * Constants.balanceToApiMultiplier
        print("amountToSend")
        print("\(amountToSendInEnqCents)")
        let fromAddress = CryptoHelper.getPublicKey()
        print("fromAddress")
        print("\(fromAddress)")
        let random = UInt32.random(in: 0...UInt32.max)
        print("random")
        print("\(random)")
        print("toaddress")
        print("\(address)")
        let txHash = CryptoHelper.buildTxHash(amount: "\(amountToSendInEnqCents)",
                                              random: "\(random)",
                                              from: fromAddress,
                                              to: address)
        print("-===-txHash")
        print(txHash)

        let sign = CryptoHelper.sign(txHash)
        print("-===-sign")
        print(sign)

        let amountStr = "\(amountToSendInEnqCents)"
        if let amoutUint64 = UInt64(amountStr) {
            print("AMOUNT")
            print("\(amoutUint64)")

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
