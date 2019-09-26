//
// Created by Daria Kokareva on 27/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

extension UIApplication {

    static func topViewController() -> UIViewController? {
        guard var top = shared.keyWindow?.rootViewController else {
            return nil
        }
        while let next = top.presentedViewController {
            top = next
        }
        return top
    }
}
