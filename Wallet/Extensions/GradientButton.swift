//
// Created by Daria Kokareva on 23/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class GradientButton: UIButton {

    private var gradientLayer: CAGradientLayer?

    @IBInspectable private var firstColor: UIColor = UIColor.clear {
        didSet {
            updateGradient()
        }
    }

    @IBInspectable private var secondColor: UIColor = UIColor.clear {
        didSet {
            updateGradient()
        }
    }

    @IBInspectable private var gradientStartPoint: CGPoint = .zero {
        didSet {
            updateGradient()
        }
    }

    @IBInspectable private var gradientEndPoint: CGPoint = CGPoint(x: 0, y: 1) {
        didSet {
            updateGradient()
        }
    }

    @IBInspectable private var gradientCornerRadius: CGFloat = 0 {
        didSet {
            updateGradient()
        }
    }

    func updateGradient() {
        gradientLayer?.removeFromSuperlayer()
        let sublayer = CAGradientLayer()
        sublayer.frame = bounds
        sublayer.colors = [firstColor, secondColor].map { $0.cgColor }
        sublayer.startPoint = gradientStartPoint
        sublayer.endPoint = gradientEndPoint
        sublayer.cornerRadius = gradientCornerRadius
        layer.addSublayer(sublayer)
        gradientLayer = sublayer
    }
}