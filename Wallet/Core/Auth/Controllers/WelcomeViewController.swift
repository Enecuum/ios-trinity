//
//  ViewController.swift
//  wallet
//
//  Created by Daria Kokareva on 01/09/2019.
//  Copyright © 2019 Enecuum. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var newWalletButton: GradientButton!
    @IBOutlet weak var importButton: GradientButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        newWalletButton.setTitle(R.string.localizable.create_new_wallet.localized(), for: .normal)
        importButton.setTitle(R.string.localizable.import_wallet.localized(), for: .normal)
    }

    // MARK: - IBActions

    @IBAction func onNewWalletClicked(_ sender: Any) {
        let authViewController = R.storyboard.auth.authViewController()!
        authViewController.authMode = .walletCreation
        present(authViewController, animated: false)
    }

    @IBAction func onImportWalletClicked(_ sender: Any) {
        let authViewController = R.storyboard.auth.authViewController()!
        authViewController.authMode = .walletImport
        present(authViewController, animated: false)
    }
}

