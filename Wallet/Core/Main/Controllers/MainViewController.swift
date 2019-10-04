//
// Created by Daria Kokareva on 24/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - IBActions

    @IBAction func onMenuClicked(_ sender: Any) {
        let menuViewController = R.storyboard.menu.menuViewController()!
        present(menuViewController, animated: false)
    }

    @IBAction func unwindToMainViewController(_ segue: UIStoryboardSegue) {
    }
}
