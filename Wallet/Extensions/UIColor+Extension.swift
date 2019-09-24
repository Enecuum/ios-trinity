//
// Created by Daria Kokareva on 24/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

extension UIColor {

    class func gradientFromColors(_ start: UIColor, _ middle: UIColor, _ end: UIColor, size: CGSize) -> UIColor {
        UIGraphicsBeginImageContext(size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        let colors = [start.cgColor,/* middle.cgColor, */end.cgColor] as CFArray
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors, locations: /*[0, 0.4, 1]*/nil)!
        context.drawLinearGradient(gradient,
                                   start: CGPoint(x: 0, y: /*size.height / 2*/0),
                                   end: CGPoint(x: size.width * 3, y: size.height * 3/* / 2*/),
                                   options: CGGradientDrawingOptions(rawValue: 0))
        let image: UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return UIColor(patternImage: image)
    }
}