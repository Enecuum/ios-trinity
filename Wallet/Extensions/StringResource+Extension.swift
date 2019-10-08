//
// Created by Daria Kokareva on 08/10/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import Foundation
import Foundation
import Rswift

extension StringResource {
    func localized(_ languageCode: String? = nil) -> String {
        let preferredLanguage = languageCode ?? Localization.preferredAppLanguageCode
        let fallback = bundle.localizedString(forKey: key, value: key, table: tableName)

        guard let localizedPath = bundle.path(forResource: preferredLanguage, ofType: "lproj"),
              let localizedBundle = Bundle(path: localizedPath) else {
            return fallback
        }
        return localizedBundle.localizedString(forKey: key, value: fallback, table: tableName)
    }
}