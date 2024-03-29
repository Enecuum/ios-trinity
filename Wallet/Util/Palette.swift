//
// Created by Daria Kokareva on 2019-04-15.
// Copyright (c) 2019 spotelf. All rights reserved.
//

import UIKit

struct Palette {

    static let errorRed = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
    static let borderGray = UIColor(red: 92 / 255, green: 97 / 255, blue: 121 / 255, alpha: 1)

    static let inputGradient = [UIColor.init(white: 1, alpha: 0.8), UIColor.init(white: 1, alpha: 0.1)]
    static let inputErrorGradient = [UIColor.red,
                                     UIColor.init(red: 126 / 255, green: 75 / 255, blue: 75 / 255, alpha: 1),
                                     UIColor.init(white: 1, alpha: 0.1)]

    static let linkColor = UIColor(red: 60 / 255, green: 152 / 255, blue: 248 / 255, alpha: 1)

    static let textFadeColor = UIColor(red: 54 / 255, green: 56 / 255, blue: 74 / 255, alpha: 1)

    static let buyTabsBackground = UIColor(red: 34 / 255, green: 35 / 255, blue: 41 / 255, alpha: 0.48)
}