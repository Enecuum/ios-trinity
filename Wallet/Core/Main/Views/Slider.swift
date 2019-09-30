//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class Slider: UISlider {

    @IBInspectable open var trackWidth: CGFloat = 40 {
        didSet {
            setNeedsDisplay()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setThumbImage(R.image.transfer.thumb()!, for: .normal)
        setThumbImage(R.image.transfer.thumb()!, for: .highlighted)

        var leftTrackImage = R.image.transfer.minTrack()!
       // let insets: UIEdgeInsets = UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
       // leftTrackImage = leftTrackImage.resizableImage(withCapInsets: insets)
        setMinimumTrackImage(leftTrackImage, for: .normal)

        var rightTrackImage = R.image.transfer.maxTrack()!
       // rightTrackImage = rightTrackImage.resizableImage(withCapInsets: insets)
        setMaximumTrackImage(rightTrackImage, for: .normal)
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