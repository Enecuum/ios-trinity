//
// Created by Daria Kokareva on 24/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class TransferViewController: UIViewController {

    @IBOutlet weak var balanceAmountLabel: UILabel!
    @IBOutlet weak var tabsView: TabsView!
    @IBOutlet weak var sendView: SendView!
    @IBOutlet weak var receiveView: ReceiveView!
    @IBOutlet weak var swapView: SwapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tabsView.setButtonTitles(buttonTitles: ["Send", "Receive", "SWAP"])
        tabsView.selectorViewColor = .white
        tabsView.selectorTextColor = .white
        tabsView.textColor = .white
        tabsView.delegate = self

        sendView.delegate = self
        sendView.isHidden = false
        receiveView.isHidden = true
        swapView.isHidden = true

        fetchBalance()
    }

    // MARK: - Server

    private func fetchBalance() {
        ApiClient.balance(id: CryptoHelper.getAddress()) { [weak self] result in
            switch result {
            case .success(let balanceAmount):
                print(balanceAmount)

                guard let decimalAmount = Decimal(string: String(balanceAmount.amount)) else {
                    print("Failed to convert balanceAmount")
                    return
                }
                let amount = decimalAmount * Decimal(0.0000000001)
                self?.balanceAmountLabel.text = "\(amount)"

                self?.sendView.updateBalance(amount)
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

extension TransferViewController: SendViewDelegate {
    func updateBalance() {
        fetchBalance()
    }
}
