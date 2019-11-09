//
// Created by Daria Kokareva on 24/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit
import QRCodeReader
import AVFoundation

class RoiViewController: UIViewController {

    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var balanceAmountLabel: UILabel!

    @IBOutlet weak var toUsdLabel: UILabel!
    @IBOutlet weak var usdAmountLabel: UILabel!

    
    struct Constants {
        static let apiToBalanceMultiplier: NSDecimalNumber = NSDecimalNumber(mantissa: 1,
                                                                             exponent: -10,
                                                                             isNegative: false)
        static let balanceToApiMultiplier: NSDecimalNumber = NSDecimalNumber(mantissa: 1,
                                                                             exponent: 10,
                                                                             isNegative: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dismissKeyBoardOnTouchOutside()

        balanceTitleLabel.text = R.string.localizable.balance.localized()

        balanceAmountLabel.text = "\(Defaults.getBalance() ?? 0)"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        fetchBalance { [weak self] amount in
            if let amount = amount {
                Defaults.saveBalance(amount)
                self?.balanceAmountLabel.text = "\(amount)"
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
}
