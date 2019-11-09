//
// Created by Daria Kokareva on 24/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainTabsView: BottomTabsView!

    private enum State: Int {
        case home = 0
        case stats
        case transfer
        case roi
    }

    private var state: State?
    
    private var currentViewController: UIViewController?
    private var transferViewController: TransferViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        Defaults.setRunOnceFlag()

        mainTabsView.setButtonImages(buttonImages: [R.image.bottomTabs.home()!, R.image.bottomTabs.stats()!, R.image.bottomTabs.transfer()!, R.image.bottomTabs.roi()!])
        mainTabsView.textColor = .white
        mainTabsView.selectorTextColor = .white
        mainTabsView.delegate = self

        if state == nil {
            transit(to: .home)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let transferViewController = segue.destination as? TransferViewController {
            self.transferViewController = transferViewController
        }
    }

    // MARK: - Transitions

    private func transit(to state: State) {
        if let vc = viewController(for: state) {
            currentViewController?.removeFromParentVc()
            addChildVc(vc, in: containerView)
            currentViewController = vc
            self.state = state
        }
    }

    private func viewController(for state: State) -> UIViewController? {
        switch state {
        case .home:
            return R.storyboard.main.homeViewController()
        case .stats:
            return R.storyboard.main.statisticsViewController()
        case .transfer:
            return R.storyboard.main.transferViewController()
        case .roi:
            return R.storyboard.main.statisticsViewController()
        }
    }

    // MARK: - IBActions

    @IBAction func onMenuClicked(_ sender: Any) {
        let menuViewController = R.storyboard.menu.menuViewController()!
        present(menuViewController, animated: false)
    }

    @IBAction func unwindToMainViewController(_ segue: UIStoryboardSegue) {
        if let _ = segue.source as? PrivateKeyViewController {
            transferViewController?.resetBalance()
        }
    }
}

extension MainViewController: BottomTabsDelegate {
    func changeToIndex(index: Int) {
        if let state = State(rawValue: index) {
            transit(to: state)
        }
    }
}
