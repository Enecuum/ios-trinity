//
// Created by Daria Kokareva on 30/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class SocialsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = R.string.localizable.community.localized()
    }

    // MARK: - IBActions

    @IBAction func onFbClicked(_ sender: Any) {
        Browser.openUrl("https://www.facebook.com/enecuum.EN")
    }

    @IBAction func onTwitterClicked(_ sender: Any) {
        Browser.openUrl("https://twitter.com/enq_enecuum")
    }

    @IBAction func onMediumClicked(_ sender: Any) {
        Browser.openUrl("https://medium.com/@EnqBlockchain")
    }

    @IBAction func onGithubClicked(_ sender: Any) {
        Browser.openUrl("https://github.com/Enecuum")
    }

    @IBAction func onBitcoinClicked(_ sender: Any) {
        Browser.openUrl("https://bitcointalk.org/index.php?topic=2939909.0;topicseen")
    }

    @IBAction func onLinkedInClicked(_ sender: Any) {
        Browser.openUrl("https://www.linkedin.com/company/enecuum-limited")
    }

    @IBAction func onYouTubeClicked(_ sender: Any) {
        Browser.openUrl("https://www.youtube.com/channel/UCyZqNfzK_PP82nkAVOlmN4Q")
    }

    @IBAction func onTelegramClicked(_ sender: Any) {
        Browser.openUrl("https://t.me/Enecuum_EN")
    }

    @IBAction func onBackClicked(_ sender: Any) {
        dismiss(animated: false)
    }
}
