//
// Created by Daria Kokareva on 08/10/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import Foundation

class Resources {
    static func plist(name: String) -> [String]? {
        if let path = Bundle.main.path(forResource: name, ofType: "plist"),
           let xml = FileManager.default.contents(atPath: path) {
            return (try? PropertyListSerialization.propertyList(from: xml,
                                                                options: .mutableContainersAndLeaves,
                                                                format: nil)) as? [String]
        }
        return nil
    }
}
