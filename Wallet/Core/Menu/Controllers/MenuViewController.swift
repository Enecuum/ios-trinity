//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBAction func onDismissClicked(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func onLogOutClicked(_ sender: Any) {
        AuthManager.signOut()

        let initialViewController = R.storyboard.auth().instantiateInitialViewController()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window!.rootViewController = initialViewController
    }
}