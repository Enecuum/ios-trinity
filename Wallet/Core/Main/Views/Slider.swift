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

        let leftTrackImage = R.image.transfer.minTrack()!
        setMinimumTrackImage(leftTrackImage, for: .normal)

        let rightTrackImage = R.image.transfer.maxTrack()!
        setMaximumTrackImage(rightTrackImage, for: .normal)

        addTapGesture()
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

    public func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tap)
    }

    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self)
        let percent = minimumValue + Float(location.x / bounds.width) * maximumValue
        setValue(percent, animated: true)
        sendActions(for: .valueChanged)
    }
    /*override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        true
    }*/
}