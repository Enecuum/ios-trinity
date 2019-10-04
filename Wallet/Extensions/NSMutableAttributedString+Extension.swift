//
// Created by Daria Kokareva on 04/10/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    func setAsLink(text: String, url: String) {
        let foundRange = mutableString.range(of: text)
        if foundRange.location != NSNotFound {
            addAttribute(.link, value: url, range: foundRange)
        }
    }
}