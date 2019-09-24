//
//  ViewController.swift
//  wallet
//
//  Created by Daria Kokareva on 01/09/2019.
//  Copyright © 2019 Enecuum. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

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

