//
// Created by Daria Kokareva on 23/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

//TODO: make extension
class GradientView: UIView {

    var gradientIsVisible: Bool = true {
        didSet {
            gradientLayer?.isHidden = !gradientIsVisible
        }
    }

    override var bounds: CGRect {
        didSet {
            updateGradient()
        }
    }
    override var frame: CGRect {
        didSet {
            updateGradient()
        }
    }

    // MARK: - Private Properties

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

    // MARK: - Public Methods

    func updateGradient() {
        gradientLayer?.removeFromSuperlayer()
        let sublayer = CAGradientLayer()
        sublayer.frame = bounds
        sublayer.colors = [firstColor, secondColor].map { $0.cgColor }
        sublayer.startPoint = gradientStartPoint
        sublayer.endPoint = gradientEndPoint
        sublayer.cornerRadius = gradientCornerRadius
        layer.insertSublayer(sublayer, at: 0)
        gradientLayer = sublayer
    }
}