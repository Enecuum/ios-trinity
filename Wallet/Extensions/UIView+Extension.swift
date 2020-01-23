//
// Created by Daria Kokareva on 23/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }

    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }

    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }

    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }

    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    func rotate(duration: Double = 1) {
        if layer.animation(forKey: "rotationanimationkey") == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")

            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = Float.infinity

            layer.add(rotationAnimation, forKey: "rotationanimationkey")
        }
    }

    func showLoader() {
        let loader = Loader(frame: frame)
        self.addSubview(loader)
    }

    func hideLoader() {
        if let loader = subviews.first(where: { $0 is Loader }) {
            loader.removeFromSuperview()
        }
    }

    func showToastMessage(_ text: String, extraPadding: CGFloat = 0) {
        makeToast(text, duration: 2, position: .custom(extraPadding))
    }

    class Loader: UIView {

        override init(frame: CGRect) {
            super.init(frame: frame)
            addLoader()
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func addLoader() {
            let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            addSubview(activityIndicator)
            activityIndicator.center = center
            activityIndicator.startAnimating()
        }
    }
}