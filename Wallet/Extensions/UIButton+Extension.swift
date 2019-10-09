//
// Created by Daria Kokareva on 09.10.2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

extension UIButton {
    func multilineLabel() {
        titleLabel?.textAlignment = .center
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.numberOfLines = 0
    }
}