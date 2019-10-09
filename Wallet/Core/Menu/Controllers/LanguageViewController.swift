//
// Created by Daria Kokareva on 07/10/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class LanguageViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!

    struct Constants {
        static let unwindSegueId = "unwindToMainSegue"
    }

    private struct LanguageItem {
        let label: String
        let code: String
    }

    private var languages: [LanguageItem] = []

    private let currentLanguageCode: String = Localization.preferredAppLanguageCode
    private var selectedLanguageCode: String = Localization.preferredAppLanguageCode

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = R.string.localizable.language.localized()

        tableView.register(R.nib.languageTableViewCell)

        if let languagesDict = Resources.plistDict(name: "Languages") {
            languages = languagesDict
                    .sorted(by: {
                        $0.key < $1.key
                    })
                    .map { (code, label) in
                        LanguageItem(label: label, code: code)
                    }
        }
        tableView.reloadData()
    }

    // MARK: - UI loc update

    private func changeLanguage(_ code: String) {
        Defaults.setLanguageCode(code)
        selectedLanguageCode = Localization.preferredAppLanguageCode

        titleLabel.text = R.string.localizable.language.localized()
        tableView.reloadData()
    }

    private func fakeAppReload() {
        let mainViewController = R.storyboard.main.mainViewController()
        view.window?.rootViewController = mainViewController
    }

    // MARK: - IBActions

    @IBAction func onBackClicked(_ sender: Any) {
        if currentLanguageCode != selectedLanguageCode {
            fakeAppReload()
            return
        }
        dismiss(animated: false)
    }

    @IBAction func onDismissClicked(_ sender: Any) {
        if currentLanguageCode != selectedLanguageCode {
            fakeAppReload()
            return
        }
        performSegue(withIdentifier: Constants.unwindSegueId, sender: self)
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
        cell.selectionStyle = .none
        return cell
    }
}

extension LanguageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let languageItem = languages[indexPath.row]
        changeLanguage(languageItem.code)
    }
}
