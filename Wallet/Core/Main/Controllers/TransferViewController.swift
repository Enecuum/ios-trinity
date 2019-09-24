//
// Created by Daria Kokareva on 24/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class TransferViewController: UIViewController {

    @IBOutlet weak var tabsView: TabsView!
    @IBOutlet weak var paddingView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tabsView.setButtonTitles(buttonTitles: ["Send", "Receive", "SWAP"])
        tabsView.selectorViewColor = .white
        tabsView.selectorTextColor = .white
        tabsView.textColor = .white
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        paddingView.roundCorners(corners: [.topRight, .topLeft], radius: 25)
    }
}
