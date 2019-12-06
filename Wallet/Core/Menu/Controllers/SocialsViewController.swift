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
        Browser.openUrl(R.string.untranslatable.community_fb_link())
    }

    @IBAction func onTwitterClicked(_ sender: Any) {
        Browser.openUrl(R.string.untranslatable.community_twitter_link())
    }

    @IBAction func onMediumClicked(_ sender: Any) {
        Browser.openUrl(R.string.untranslatable.community_medium_link())
    }

    @IBAction func onGithubClicked(_ sender: Any) {
        Browser.openUrl(R.string.untranslatable.community_github_link())
    }
    
    @IBAction func onForklogClicked(_ sender: Any) {
        Browser.openUrl(R.string.untranslatable.community_forklog_link())
     }

    @IBAction func onBitcoinClicked(_ sender: Any) {
        Browser.openUrl(R.string.untranslatable.community_bt_link())
    }

    @IBAction func onLinkedInClicked(_ sender: Any) {
        Browser.openUrl(R.string.untranslatable.community_linkedin_link())
    }

    @IBAction func onYouTubeClicked(_ sender: Any) {
        Browser.openUrl(R.string.untranslatable.community_youtube_link())
    }

    @IBAction func onTelegramClicked(_ sender: Any) {
        Browser.openUrl(R.string.localizable.community_telegram_link.localized())
    }

    @IBAction func onBackClicked(_ sender: Any) {
        dismiss(animated: false)
    }
}
