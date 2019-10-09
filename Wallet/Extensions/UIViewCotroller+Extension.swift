//
// Created by Daria Kokareva on 09.10.2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

extension UIViewController {
    func dismissKeyBoardOnTouchOutside() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}