//
//  ViewController.swift
//  wallet
//
//  Created by Daria Kokareva on 01/09/2019.
//  Copyright © 2019 Enecuum. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {

    var authMode: AuthMode = .walletImport

    @IBAction func onStartClicked(_ sender: Any) {
    }
    
    @IBAction func onBackClicked(_ sender: Any) {
        dismiss(animated: false)
    }
}

