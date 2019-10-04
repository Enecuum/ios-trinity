//
// Created by Daria Kokareva on 30/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class SocialsViewController: UIViewController {

    private func openUrl(_ string: String) {
        if let url = URL(string: string) {
            UIApplication.shared.open(url)
        }
    }

    @IBAction func onFbClicked(_ sender: Any) {
        openUrl("https://www.facebook.com/enecuum.EN")
    }

    @IBAction func onTwitterClicked(_ sender: Any) {
        openUrl("https://twitter.com/enq_enecuum")
    }

    @IBAction func onMediumClicked(_ sender: Any) {
        openUrl("https://medium.com/@EnqBlockchain")
    }

    @IBAction func onGithubClicked(_ sender: Any) {
        openUrl("https://github.com/Enecuum")
    }

    @IBAction func onBitcoinClicked(_ sender: Any) {
        openUrl("https://bitcointalk.org/index.php?topic=2939909.0;topicseen")
    }

    @IBAction func onLinkedInClicked(_ sender: Any) {
        openUrl("https://www.linkedin.com/company/enecuum-limited")
    }

    @IBAction func onYouTubeClicked(_ sender: Any) {
        openUrl("https://www.youtube.com/channel/UCyZqNfzK_PP82nkAVOlmN4Q")
    }

    @IBAction func onTelegramClicked(_ sender: Any) {
        openUrl("https://t.me/Enecuum_EN")
    }

    @IBAction func onBackClicked(_ sender: Any) {
        dismiss(animated: false)
    }

    @IBAction func onDismissClicked(_ sender: Any) {
        dismiss(animated: false)
    }
}
