//
// Created by Daria Kokareva on 27.11.2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class Browser {
    static func openUrl(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }

    static func openUrl(_ url: URL?) {
        if let url = url {
            UIApplication.shared.open(url)
        }
    }
}