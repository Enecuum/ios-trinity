//
// Created by Daria Kokareva on 08/10/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import Foundation
import UIKit

class Localization {

    static func setupLangAlignment() {
        UIView.appearance().semanticContentAttribute = isRTL() ? .forceRightToLeft : .forceLeftToRight
    }

    static func isRTL() -> Bool {
        Localization.preferredAppLanguageCode == "ar"
    }

    static var preferredAppLanguageCode: String {
        if let selectedLanguageCode = userSelectedLanguageCode() {
            return selectedLanguageCode
        }
        if let languagesDict = Resources.plistDict(name: "Languages"),
           let preferredLanguageCode = Bundle.main.preferredLocalizations.first,
           languagesDict.keys.contains(preferredLanguageCode) {
            return preferredLanguageCode
        }
        return "en"
    }

    static func userSelectedLanguageCode() -> String? {
        return Defaults.languageCode()
    }
}