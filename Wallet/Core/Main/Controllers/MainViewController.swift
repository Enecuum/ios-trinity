//
// Created by Daria Kokareva on 24/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainTabsView: BottomTabsView!

    private var sections: [Section]?
    private var currentSection: Section?

    private var currentViewController: UIViewController?
    private var homeViewController: HomeViewController?
    private var transferViewController: TransferViewController?
    private var roiViewController: RoiViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        Defaults.setRunOnceFlag()

        sections = [
//            Section(viewControllerId: "homeViewController", imageName: "BottomTabs/home"),
            Section(viewControllerId: "statisticsViewController", imageName: "BottomTabs/stats"),
            Section(viewControllerId: "transferViewController", imageName: "BottomTabs/transfer"),
            Section(viewControllerId: "roiViewController", imageName: "BottomTabs/roi")
        ]
        let buttonImages: [UIImage]? = sections?.map {
            UIImage(named: $0.imageName)!
        }

        mainTabsView.setButtonImages(buttonImages: buttonImages!)
        mainTabsView.delegate = self

        if currentSection == nil, let firstSection = sections?.first {
            transit(to: firstSection)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let homeViewController = segue.destination as? HomeViewController {
            self.homeViewController = homeViewController
        } else if let transferViewController = segue.destination as? TransferViewController {
            self.transferViewController = transferViewController
        } else if let roiViewController = segue.destination as? RoiViewController {
            self.roiViewController = roiViewController
        }
    }

    // MARK: - Transitions

    private func transit(to section: Section) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: section.viewControllerId) {
            currentViewController?.removeFromParentVc()
            addChildVc(vc, in: containerView)
            currentViewController = vc
            self.currentSection = section
        }
    }

    // MARK: - IBActions

    @IBAction func onMenuClicked(_ sender: Any) {
        let menuViewController = R.storyboard.menu.menuViewController()!
        present(menuViewController, animated: false)
    }

    @IBAction func unwindToMainViewController(_ segue: UIStoryboardSegue) {
        if let _ = segue.source as? PrivateKeyViewController {
            homeViewController?.resetBalance()
            transferViewController?.resetBalance()
            roiViewController?.resetBalance()
        }
    }
}

extension MainViewController: BottomTabsDelegate {
    func changeToIndex(index: Int) {
        if index < sections?.count ?? 0, let section = sections?[index] {
            transit(to: section)
        }
    }
}
