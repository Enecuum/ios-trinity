//
// Created by Daria Kokareva on 24/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    private var transferViewController: TransferViewController?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let transferViewController = segue.destination as? TransferViewController {
            self.transferViewController = transferViewController
        }
    }

    // MARK: - IBActions

    @IBAction func onMenuClicked(_ sender: Any) {
        let menuViewController = R.storyboard.menu.menuViewController()!
        present(menuViewController, animated: false)
    }

    @IBAction func unwindToMainViewController(_ segue: UIStoryboardSegue) {
        if let sourceViewController = segue.source as? PrivateKeyController {
            transferViewController?.resetBalance()
        }
    }
}
