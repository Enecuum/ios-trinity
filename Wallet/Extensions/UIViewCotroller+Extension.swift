//
// Created by Daria Kokareva on 09.10.2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

extension UIViewController {
    func addChildVc(_ vc: UIViewController, in view: UIView? = nil) {
        addChild(vc)
        if let containerView = view ?? self.view {
            vc.view.frame = CGRect(x: 0,
                                   y: 0,
                                   width: containerView.frame.size.width,
                                   height: containerView.frame.size.height)
            containerView.addSubview(vc.view)
        }
        vc.didMove(toParent: self)
    }

    func removeFromParentVc() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }

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