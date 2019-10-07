//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var hiddenView: UIView!
    
    @IBAction func onDismissClicked(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func onHiddenTap(_ sender: Any) {
        hiddenView.isHidden = false
    }
}
