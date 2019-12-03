//
// Created by Daria Kokareva on 25/09/2019.
// Copyright (c) 2019 Enecuum. All rights reserved.
//

import UIKit

class TabsBackgroundView: UIView, NibView {

    @IBOutlet weak var leftTabWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var stubWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightTabWidthConstraint: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
}
