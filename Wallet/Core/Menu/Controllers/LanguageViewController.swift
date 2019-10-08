//
// Created by Daria Kokareva on 07/10/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class LanguageViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!

    private struct LanguageItem {
        let label: String
        let code: String
    }

    private var languages: [LanguageItem] = []
    private var selectedLanguageCode: String = Localization.preferredAppLanguageCode

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = R.string.localizable.language.localized()

        tableView.register(R.nib.languageTableViewCell)

        if let languagesArray = Resources.plist(name: "Languages") {
            languages = languagesArray.map { string in
                LanguageItem(label: string, code: string)
            }
        }
        tableView.reloadData()
    }

    // MARK: - IBActions

    @IBAction func onBackClicked(_ sender: Any) {
        dismiss(animated: false)
    }
}

extension LanguageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.languageTableViewCell,
                                                 for: indexPath)!
        let languageItem = languages[indexPath.row]
        cell.itemLabel.text = languageItem.label
        cell.frameView.isHidden = languageItem.code != selectedLanguageCode
        return cell
    }
}

extension LanguageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let languageItem = languages[indexPath.row]
        Defaults.setLanguageCode(languageItem.code)
        selectedLanguageCode = Localization.preferredAppLanguageCode
        tableView.reloadData()
    }
}