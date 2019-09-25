//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class Slider: UISlider {

    @IBInspectable open var trackWidth: CGFloat = 2 {
        didSet {
            setNeedsDisplay()
        }
    }

    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let defaultBounds = super.trackRect(forBounds: bounds)

        return CGRect(
                x: defaultBounds.origin.x,
                y: defaultBounds.origin.y + defaultBounds.size.height / 2 - trackWidth / 2,
                width: defaultBounds.size.width,
                height: trackWidth
        )
    }
}