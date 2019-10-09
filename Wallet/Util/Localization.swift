//
// Created by Daria Kokareva on 08/10/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import Foundation

class Localization {

    static var preferredAppLanguageCode: String {
        if let selectedLanguageCode = userSelectedLanguageCode() {
            return selectedLanguageCode
        }
        if let languagesArray = Resources.plistArray(name: "Languages"),
           let preferredLanguageCode = Bundle.main.preferredLocalizations.first,
           languagesArray.contains(preferredLanguageCode) {
            return preferredLanguageCode
        }
        return "en"
    }

    static func userSelectedLanguageCode() -> String? {
        return Defaults.languageCode()
    }
}