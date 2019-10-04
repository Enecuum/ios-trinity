//
// Created by Daria Kokareva on 04/10/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

extension UILabel {
    func underline() {
        if let text = self.text {
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
}