//
// Created by Daria Kokareva on 30/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var versionsLabel: UILabel!
    
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var whitePaperLabel: UILabel!
    @IBOutlet weak var techPaperLabel: UILabel!
    @IBOutlet weak var termsLabel: UILabel!
    @IBOutlet weak var policyLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = R.string.localizable.about.localized()
        companyLabel.text = R.string.localizable.about_app_title.localized()
        //TODO: insert verwsions
        versionsLabel.text = R.string.localizable.about_version.localized()

        websiteLabel.text = R.string.localizable.about_site.localized()
        websiteLabel.underline()
        addGestureRecognizer(label: websiteLabel, selector: #selector(onWebsiteTap))

        whitePaperLabel.text = R.string.localizable.about_white_paper.localized()
        whitePaperLabel.underline()
        addGestureRecognizer(label: whitePaperLabel, selector: #selector(onWhitePaperTap))

        techPaperLabel.text = R.string.localizable.about_tech.localized()
        techPaperLabel.underline()
        addGestureRecognizer(label: techPaperLabel, selector: #selector(onTechPaperTap))

        termsLabel.text = R.string.localizable.about_terms.localized()
        termsLabel.underline()
        addGestureRecognizer(label: termsLabel, selector: #selector(onTermsTap))

        policyLabel.text = R.string.localizable.about_privacy.localized()
        policyLabel.underline()
        addGestureRecognizer(label: policyLabel, selector: #selector(onPolicyTap))
    }

    private func addGestureRecognizer(label: UILabel, selector: Selector) {
        let tapAction = UITapGestureRecognizer(target: self, action: selector)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapAction)
    }

    // MARK: - Selectors

    @objc private func onWebsiteTap(sender: UITapGestureRecognizer) {
        if let url = URL(string: "https://www.enecuum.com") {
            UIApplication.shared.open(url)
        }
    }

    @objc private func onWhitePaperTap(sender: UITapGestureRecognizer) {
        if let url = URL(string: "https://enecuum.com/assets/pdf/pp_en.pdf") {
            UIApplication.shared.open(url)
        }
    }

    @objc private func onTechPaperTap(sender: UITapGestureRecognizer) {
        if let url = URL(string: "https://enecuum.com/assets/pdf/tp_en.pdf") {
            UIApplication.shared.open(url)
        }
    }

    @objc private func onTermsTap(sender: UITapGestureRecognizer) {
        if let url = URL(string: "https://enecuum.com/assets/pdf/terms.pdf") {
            UIApplication.shared.open(url)
        }
    }

    @objc private func onPolicyTap(sender: UITapGestureRecognizer) {
        if let url = URL(string: "https://enecuum.com/assets/pdf/privacy.pdf") {
            UIApplication.shared.open(url)
        }
    }

    // MARK: - IBActions

    @IBAction func onBackClicked(_ sender: Any) {
        dismiss(animated: false)
    }
}
